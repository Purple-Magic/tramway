# frozen_string_literal: true

# FIXME: use default `require` method
load "#{Tramway.root}/lib/tramway/class_name_helpers.rb"
load "#{Tramway.root}/lib/tramway/record_routes_helper.rb"

# FIXME: configurate load_path
load "#{Tramway.root}/app/controllers/concerns/auth_management.rb"

class Tramway::ApplicationController < ActionController::Base
  include Tramway::ClassNameHelpers
  include Tramway::AuthManagement
  include Tramway::RecordRoutesHelper

  before_action :application
  before_action :load_extensions
  before_action :notifications
  before_action :notifications_count
  before_action :collections_counts, if: :model_given?
  before_action :authenticate_user!
  before_action :check_available!
  before_action :check_available_scope!, if: :model_given?, only: :index

  protect_from_forgery with: :exception

  protected

  def admin_model
    ::Tramway.admin_model
  end

  def check_available!
    return if session_path?

    return unless !model_given? && !form_given?

    Tramway::Error.raise_error :tramway, :application_controller, :model_or_form_not_available
  end

  def check_available_scope!
    raise 'Scope is not available' if params[:scope].present? && !available_scope_given?
  end

  def collections_counts
    @counts = decorator_class.collections.reduce({}) do |hash, collection|
      records = model_class.public_send(collection)
      records = filtering records
      records = list_filtering records

      hash.merge! collection => records.public_send(current_user_role_scope, current_user.id).count
    end
  end

  def notifications
    if current_user
      @notifications ||= Tramway.notificable_queries&.reduce({}) do |hash, notification|
        hash.merge! notification[0] => notification[1].call(current_user)
      end
    end
    @notifications
  end

  def notifications_count
    @notifications_count = notifications&.reduce(0) do |count, notification|
      count += notification[1].count # rubocop:disable Lint/UselessAssignment
    end
  end

  include Tramway::ClassNameHelpers

  def model_class
    model_class_name(params[:model] || params[:form])
  end

  def decorator_class
    decorator_class_name
  end

  def admin_form_class
    class_name = "::#{current_user.role.camelize}::#{model_class}Form"

    unless defined? class_name
      Tramway::Error.raise_error(
        :tramway,
        :application,
        :create_form_for_role,
        role: current_user.role,
        model_class: model_class,
        class_name: class_name
      )
    end

    class_name.constantize
  end

  def model_given?
    current_user.present? && (available_models_given? || singleton_models_given?)
  end

  def form_given?
    Tramway.forms.include? params[:form].underscore.sub(%r{^admin/}, '').sub(/_form$/, '') if params[:form].present?
  end

  def available_scope_given?
    params[:scope].present? && params[:scope].in?(decorator_class.collections.map(&:to_s))
  end

  def available_models_given?
    check_models_given? :available
  end

  def singleton_models_given?
    check_models_given? :singleton
  end

  private

  def check_models_given?(model_type)
    models = Tramway.send("#{model_type}_models", role: current_user.role)
    models.any? && params[:model].in?(models.map(&:to_s))
  end

  def session_path?
    request.path.in?(['/admin/session/new', '/admin/session', '/admin/sign_out'])
  end

  def application
    return unless Tramway.application

    @application ||= Tramway.application&.model_class&.first || Tramway.application
  end

  def load_extensions
    Tramway::Extensions.load if defined? Tramway::Extensions
  end

  def authenticated_user
    (defined?(current_user) && current_user.try(:model)) || (defined?(current_user) && current_user.model)
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

  def current_user_role_scope
    "#{current_user.role}_scope"
  end

  def filtering(records)
    if params[:filter].present?
      params[:filter] = JSON.parse params[:filter] if params[:filter].is_a? String
      records.ransack(params[:filter]).result(distinct: true)
    else
      records
    end
  end
end
