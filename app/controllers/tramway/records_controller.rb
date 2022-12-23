# frozen_string_literal: true

class Tramway::RecordsController < Tramway::ApplicationController
  def index
    records = model_class.order(id: :desc).send scope
    records = full_text_search records
    records = filtering records
    records = list_filtering records
    records = records.public_send "#{current_user.role}_scope", current_user.id
    @records = decorator_class.decorate records.page params[:page]
  end

  def show
    @record = decorator_class.decorate model_class.find params[:id]
  end

  def new
    @record_form = admin_form_class.new model_class.new
  end

  def create
    @record_form = admin_form_class.new model_class.new
    if @record_form.submit params[:record]
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(@record_form.model)
    else
      render :new
    end
  end

  def edit
    @record_form = admin_form_class.new model_class.find params[:id]
  end

  def update
    @record_form = admin_form_class.new model_class.find params[:id]
    if state_event.present?
      if record_state_event?
        record_make_state_event!
        default_redirect
      end
    elsif @record_form.submit params[:record]
      default_redirect
    else
      render :edit
    end
  end

  def destroy
    record = model_class.find params[:id]
    record.destroy
    redirect_to params[:redirect].present? ? params[:redirect] : records_path
  end

  private

  def default_redirect
    redirect_to params[:redirect].present? ? params[:redirect] : record_path(@record_form.model)
  end

  def record_state_event?
    @record_form.model.public_send("may_#{state_event}?")
  end

  def record_make_state_event!
    @record_form.model.send("#{state_event}!")
  end

  def state_event
    params[:record][:aasm_event]
  end

  def scope
    params[:scope].present? ? params[:scope] : :all
  end

  def full_text_search(records)
    params[:search].present? ? records.full_text_search(params[:search]) : records
  end

  def filtering(records)
    if params[:filter].present?
      params[:filter] = JSON.parse params[:filter] if params[:filter].is_a? String
      records.ransack(params[:filter]).result(distinct: true)
    else
      records
    end
  end

  def list_filtering(records)
    params[:list_filters]&.each do |filter, _value|
      case decorator_class.list_filters[filter.to_sym][:type]
      when :select
        records = list_filtering_select records, filter
      when :dates
        records = list_filtering_dates records, filter
      end
    end

    records
  end

  def list_filtering_select(records, filter)
    value.present? ? decorator_class.list_filters[filter.to_sym][:query].call(records, value) : records
  end

  def list_filtering_dates(records, filter)
    begin_date = date_filter :begin, filter
    end_date = date_filter :end, filter
    if begin_date.present? && end_date.present? && value.present?
      decorator_class.list_filters[filter.to_sym][:query].call(records, begin_date, end_date)
    else
      records
    end
  end

  def date_filter(type, filter)
    params[:list_filters][filter.to_sym]["#{type}_date".to_sym]
  end
end
