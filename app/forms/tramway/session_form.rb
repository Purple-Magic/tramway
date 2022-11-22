# frozen_string_literal: true

module Tramway
  class SessionForm < ::Tramway::ApplicationForm
    properties :email
    attr_accessor :password

    def validate(params)
      (!model.new_record? && model.authenticate(params[:password])).tap do |result|
        add_wrong_email_or_password_error unless result
      end
    end

    private

    def add_wrong_email_or_password_error
      errors.add(:email, I18n.t('errors.wrong_email_or_password'))
    end
  end
end
