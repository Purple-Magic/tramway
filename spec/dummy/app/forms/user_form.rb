# frozen_string_literal: true

# Test form for basic functions testing
class UserForm < Tramway::BaseForm
  properties :email, :role, :country, :avatar, :personal_info

  normalizes :email, with: ->(value) { value.strip.downcase }
  validates :email, format: { with: /@/ }, allow_nil: true

  fields email: :email, first_name: :text
end
