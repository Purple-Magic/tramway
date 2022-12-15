# frozen_string_literal: true

# FIXME configurate load_path
load "#{Tramway.root}/app/controllers/concerns/auth_management.rb"

class Tramway::SessionsController < Tramway::ApplicationController
  before_action :redirect_if_signed_in, except: :destroy

  # FIXME should be included in Tramway::ApplicationController
  include Tramway::AuthManagement

  def new
    @session_form = Tramway::SessionForm.new Tramway::User.new
  end

  def create
    # FIXME remove last `/` another way
    root_path = Tramway::Engine.routes.url_helpers.root_path[0..-2]
    @session_form = ::Tramway::SessionForm.new params[:model].constantize.find_by email: params[:user][:email]
    if @session_form.model.present?
      if @session_form.validate params[:user]
        sign_in @session_form.model
        redirect_to [(params[:success_redirect] || root_path), '?', { flash: :success_user_sign_in }.to_query].join
      else
        redirect_to [(params[:error_redirect] || root_path), '?', { flash: :error_user_sign_in }.to_query].join
      end
    else
      redirect_to [(params[:error_redirect] || root_path), '?', { flash: :error_user_sign_in }.to_query].join
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
end
