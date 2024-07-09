# frozen_string_literal: true

# Test form for basic functions testing for Admin panel
module Admin
  class UserForm < Tramway::BaseForm
    properties :email, :role

    normalizes :email, with: ->(value) { value.strip.downcase }
  end
end
