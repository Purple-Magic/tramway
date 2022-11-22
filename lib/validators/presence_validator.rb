# frozen_string_literal: true

class PresenceValidator
  def initialize(attributes); end

  def valid?(value)
    value.present?
  end
end
