# frozen_string_literal: true

module Tramway::AuthManagement
  def sign_in(user)
    session[:tramway_user_id] = user.id
  end

  def sign_out
    session[:tramway_user_id] = nil
  end

  def signed_in?
    current_user
  end

  def authenticate_user!
    redirect_to Tramway::Engine.routes.url_helpers.new_session_path if !session_path? && !signed_in?
  end

  def current_user
    user = Tramway::User.find_by id: session[:tramway_user_id]
    return false unless user

    Tramway::UserDecorator.decorate user
  end
end
