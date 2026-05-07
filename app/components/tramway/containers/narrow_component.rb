# frozen_string_literal: true

module Tramway
  module Containers
    # Default page container in Tramway
    class NarrowComponent < Tramway::BaseComponent
      option :id, optional: true, default: proc { SecureRandom.uuid }
      option :options, optional: true, default: proc { {} }

      def container_classes
        options_classes = options[:class] || ''

        theme_classes(
          classic: 'container mx-auto flex w-full justify-center p-4 text-zinc-200 ' + options_classes
        )
      end
    end
  end
end
