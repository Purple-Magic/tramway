# frozen_string_literal: true

# Test form for basic functions testing
class UserForm < Tramway::BaseForm
  properties :email, :role, :country, :avatar, :personal_info

  normalizes :email, with: ->(value) { value.strip.downcase }

  fields email: :email, first_name: :text
end
