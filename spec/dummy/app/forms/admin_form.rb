# frozen_string_literal: true

# Test form for form-inheritance testing
class AdminForm < UserForm
  properties :permissions

  normalizes :permissions, with: ->(value) { value.is_a?(Array) ? value : value.split(',') }
end
