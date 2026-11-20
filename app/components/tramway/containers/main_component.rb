# frozen_string_literal: true

module Tramway
  module Containers
    # Main container for tailwind-styled layout
    class MainComponent < Tramway::BaseComponent
      option :options, optional: true, default: proc { {} }

      def container_classes
        ['tramway-main', options[:class]].compact.join(' ')
      end
    end
  end
end
