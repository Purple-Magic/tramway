# frozen_string_literal: true

module Tramway
  module ApplicationForms
    module AssociationClassHelpers
      def associations(*properties)
        properties.each { |property| association property }
      end
    end
  end
end
