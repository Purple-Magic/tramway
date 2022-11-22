# frozen_string_literal: true

class Tramway::SessionsController < ::Tramway::ApplicationController
  before_action :redirect_if_signed_in, except: :destroy
  skip_before_action :check_available!
  skip_before_action :collections_counts

  def new
    @session_form = ::Tramway::Auth::SessionForm.new admin_model.new
  end

  def create
    @session_form = ::Tramway::Auth::SessionForm.new admin_model.find_or_initialize_by email: params[:user][:email]
    if @session_form.validate params[:user]
      admin_sign_in @session_form.model
      redirect_to Tramway::Engine.routes.url_helpers.root_path
    else
      render :new
    end
  end

  def destroy
    admin_sign_out
    redirect_to '/admin/session/new'
  end

  private

  def redirect_if_signed_in
    redirect_to Tramway::Engine.routes.url_helpers.root_path if current_admin
  end

  def admin_sign_in(user)
    session[:admin_id] = user.id
  end

  def admin_sign_out
    session[:admin_id] = nil
  end
end
