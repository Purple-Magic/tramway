# frozen_string_literal: true

# FIXME: configurate load_path
load "#{Tramway.root}/app/controllers/concerns/auth_management.rb"

class Tramway::SessionsController < Tramway::ApplicationController
  before_action :redirect_if_signed_in, except: :destroy

  # FIXME: should be included in Tramway::ApplicationController
  include Tramway::AuthManagement

  def new
    @session_form = Tramway::SessionForm.new Tramway::User.new
  end

  def create
    @session_form = Tramway::SessionForm.new record

    if @session_form.validate params[:user]
      sign_in @session_form.model
      redirect_to redirect_params_for status: :success
    else
      render :new
    end
  end

  def destroy
    root_path = Tramway::Engine.routes.url_helpers.root_path
    sign_out params[:model]

    redirect_to params[:redirect] || root_path
  end

  private

  def redirect_if_signed_in
    if params[:model].present? && signed_in? && request.env['PATH_INFO'] != Tramway.root_path_for(current_user.class)
      redirect_to Tramway.root_path_for(current_user.class)
    end
  end

  def record
    @record ||= params[:model].constantize.find_by email: params[:user][:email]
  end

  def root_path
    Tramway::Engine.routes.url_helpers.root_path[0..-2]
  end

  def redirect_params_for(status:)
    Tramway::Engine.routes.url_helpers.new_session_path flash: "#{status}_user_sign_in".to_sym
  end
end
