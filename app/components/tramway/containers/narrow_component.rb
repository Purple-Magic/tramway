# frozen_string_literal: true

module Tramway
  module Containers
    # Default page container in Tramway
    class NarrowComponent < Tramway::BaseComponent
      option :id, optional: true, default: proc { SecureRandom.uuid }
      option :options, optional: true, default: proc { {} }

      def container_classes
        [
          'tramway-container',
          options[:class]
        ].compact.join(' ')
      end
    end
  end
end
