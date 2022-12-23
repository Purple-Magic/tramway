# frozen_string_literal: true

class Tramway::RecordsController < Tramway::ApplicationController
  def index
    scope = params[:scope].present? ? params[:scope] : :all
    records = model_class.order(id: :desc).send scope
    records = records.full_text_search params[:search] if params[:search].present?
    if params[:filter].present?
      params[:filter] = JSON.parse params[:filter] if params[:filter].is_a? String
      records = records.ransack(params[:filter]).result(distinct: true)
    end
    params[:list_filters]&.each do |filter, value|
      case decorator_class.list_filters[filter.to_sym][:type]
      when :select
        records = decorator_class.list_filters[filter.to_sym][:query].call(records, value) if value.present?
      when :dates
        begin_date = params[:list_filters][filter.to_sym][:begin_date]
        end_date = params[:list_filters][filter.to_sym][:end_date]
        if begin_date.present? && end_date.present? && value.present?
          records = decorator_class.list_filters[filter.to_sym][:query].call(records, begin_date, end_date)
        end
      end
    end
    records = records.send "#{current_user.role}_scope", current_user.id
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
end
