# frozen_string_literal: true

module Tramway
  module Delegating
    module ClassHelper
      def delegate_attributes(*attributes)
        attributes.each do |attr|
          delegate attr, to: :object
        end
      end
    end
  end
end
