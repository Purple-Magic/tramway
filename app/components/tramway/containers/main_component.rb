# frozen_string_literal: true

module Tramway
  module Containers
    # Main container for tailwind-styled layout
    class MainComponent < Tramway::BaseComponent
      option :options, optional: true, default: proc { {} }

      def container_classes
        options_classes = options[:class] || ''

        theme_classes(
          classic: "min-h-dvh bg-zinc-950 text-zinc-200 #{options_classes}"
        )
      end
    end
  end
end
