# frozen_string_literal: true

# Test form for form-inheritance testing
class AdminForm < UserForm
  properties :permissions, :first_name, :last_name

  normalizes :permissions, with: ->(value) { value.is_a?(Array) ? value : value.split(',') }
  normalizes :first_name, :last_name, with: ->(value) { value&.strip }
end
