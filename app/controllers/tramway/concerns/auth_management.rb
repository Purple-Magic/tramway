# frozen_string_literal: true

module Tramway
  module AuthManagement
    def sign_in(user)
      session[user_id_key(user.class)] = user.id
    end

    def sign_out(user_class = ::Tramway::User::User)
      session[user_id_key(user_class.constantize)] = nil if user_class.present?
    end

    def signed_in?(user_class = ::Tramway::User::User)
      current_user(user_class)
    end

    def authenticate_user!(user_class = ::Tramway::User::User)
      redirect_to new_session_path unless signed_in?(user_class)
    end

    def current_user(user_class = ::Tramway::User::User)
      user = user_class.find_by id: session[user_id_key(user_class)]
      return false unless user

      "#{user_class}Decorator".constantize.decorate user
    end

    private

    def user_id_key(user_class)
      "#{user_class.to_s.underscore}_id".to_sym
    end
  end
end
