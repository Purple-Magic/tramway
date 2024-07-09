# frozen_string_literal: true

module Admin
  # Test form for basic functions testing for Admin panel
  class UserForm < Tramway::BaseForm
    properties :email, :role

    normalizes :email, with: ->(value) { value.strip.downcase }
  end
end
