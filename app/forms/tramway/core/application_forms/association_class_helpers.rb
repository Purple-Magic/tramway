# frozen_string_literal: true

module Tramway::Core::ApplicationForms::AssociationClassHelpers
  def associations(*properties)
    properties.each { |property| association property }
  end
end
