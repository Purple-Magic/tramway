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

    raise 'Tramway - Model or Form is not available. Looks like current user does not have access to change this model. Update your tramway initializer file'
  end

  def check_available_scope!
    raise 'Scope is not available' if params[:scope].present? && !available_scope_given?
  end

  def collections_counts
    @counts = decorator_class.collections.reduce({}) do |hash, collection|
      records = model_class.send(collection)
      records = records.send "#{current_user.role}_scope", current_user.id
      records = records.ransack(params[:filter]).result if params[:filter].present?
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
      hash.merge! collection => records.send("#{current_user.role}_scope", current_user.id).count
    end
  end

  def application
    return unless ::Tramway.application

    @application = Tramway.application&.model_class&.first || Tramway.application
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
      count += notification[1].count
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
      raise "Tramway - you should create form for role `#{current_user.role}` to edit #{model_class} model. It should be named #{class_name}"
    end

    class_name.constantize
  end

  def model_given?
    current_user.present? && (available_models_given? || singleton_models_given?)
  end

  def form_given?
    # FIXME: add tramway error locales to the tramway admin gem
    # Tramway::Error.raise_error(
    #  :tramway, :admin, :application_controller, :form_given, :model_not_included_to_tramway_admin,
    #  model: params[:model]
    # )
    # raise "Looks like model #{params[:model]} is not included to tramway-admin for `#{current_user.role}` role. Add it in the `config/initializers/tramway.rb`. This way `Tramway.set_available_models(#{params[:model]})`"
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
    models = ::Tramway.send("#{model_type}_models", role: current_user.role)
    models.any? && params[:model].in?(models.map(&:to_s))
  end

  def session_path?
    request.path.in?(['/admin/session/new', '/admin/session', '/admin/sign_out'])
  end

  def application
    return unless ::Tramway.application

    @application ||= Tramway.application&.model_class&.first || Tramway.application
  end

  def load_extensions
    ::Tramway::Extensions.load if defined? ::Tramway::Extensions
  end

  def model_class
    params[:model].constantize
  end

  def authenticated_user
    (defined?(current_user) && current_user.try(:model)) || (defined?(current_user) && current_user.model)
  end
end
