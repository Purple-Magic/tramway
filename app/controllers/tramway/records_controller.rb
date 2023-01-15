# frozen_string_literal: true

class Tramway::RecordsController < Tramway::ApplicationController
  def index
    records = model_class.order(id: :desc).send scope
    records = full_text_search records
    records = filtering records
    records = list_filtering records
    records = records.public_send current_user_role_scope, current_user.id
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
    if @record_form.submit params[attributes_key]
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
    elsif @record_form.submit params[attributes_key]
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
    params[attributes_key][:aasm_event]
  end

  def scope
    params[:scope].present? ? params[:scope] : :all
  end

  def full_text_search(records)
    params[:search].present? ? records.full_text_search(params[:search]) : records
  end

  def attributes_key
    key = model_class.to_s.underscore

    params[key].present? ? key : :record
  end
end
