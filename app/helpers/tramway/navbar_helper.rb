# frozen_string_literal: true

module Tramway
  module NavbarHelper
    def customized_admin_navbar_given?
      customized_admin_navbar.present?
    end

    def customized_admin_navbar
      ::Tramway.customized_admin_navbar
    end
  end
end
