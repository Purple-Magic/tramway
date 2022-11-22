# frozen_string_literal: true

module Tramway::ApplicationForms::ObjectHelpers
  def to_model
    self
  end

  def persisted?
    model.id.nil?
  end

  def model
    @object
  end
end
