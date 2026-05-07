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
          classic: 'container p-4 flex align-center justify-center w-full mx-auto ' \
                   'shadow-inner rounded-xl bg-zinc-950 text-zinc-50' + options_classes
        )
      end
    end
  end
end
