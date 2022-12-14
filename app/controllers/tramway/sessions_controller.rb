# frozen_string_literal: true

module Tramway
  class SessionsController < Tramway::ApplicationController
    before_action :redirect_if_signed_in, except: :destroy

    def new
      @session_form = Tramway::SessionForm.new Tramway::User.new
    end

    def create
      @session_form = ::Tramway::SessionForm.new params[:model].constantize.find_by email: params[:user][:email]
      if @session_form.model.present?
        if @session_form.validate params[:user]
          sign_in @session_form.model
          redirect_to [params[:success_redirect], '?', { flash: :success_user_sign_in }.to_query].join || ::Tramway.root_path_for(@session_form.model.class)
        else
          redirect_to [params[:error_redirect], '?', { flash: :error_user_sign_in }.to_query].join || ::Tramway.root_path_for(@session_form.model.class)
        end
      else
        redirect_to [params[:error_redirect], '?', { flash: :error_user_sign_in }.to_query].join || ::Tramway.root_path_for(params[:model].constantize)
      end
    end

    def destroy
      root_path = Tramway::Engine.routes.url_helpers.root_path
      sign_out params[:model]

      redirect_to params[:redirect] || root_path
    end

    private

    def redirect_if_signed_in
      if params[:model].present? && signed_in?(params[:model].constantize) && request.env['PATH_INFO'] != Tramway.root_path_for(current_user.class)
        redirect_to Tramway.root_path_for(current_user.class)
      end
    end
  end
end
