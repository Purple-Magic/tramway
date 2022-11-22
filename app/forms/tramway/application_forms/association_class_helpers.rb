# frozen_string_literal: true

module Tramway::ApplicationForms::AssociationClassHelpers
  def associations(*properties)
    properties.each { |property| association property }
  end
end
