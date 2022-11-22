# frozen_string_literal: true

class Tramway::ApplicationController < ActionController::Base
  before_action :application
  before_action :load_extensions

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
    (defined?(current_user) && current_user.try(:model)) || (defined?(current_admin) && current_admin.model)
  end
end
