# frozen_string_literal: true

module Tailwinds
  module Nav
    # Render button styled with Tailwind using button_to or link_to methods
    #
    class ItemComponent < TailwindComponent
      def initialize(**options)
        @href = options[:href]
        @style = 'text-white hover:bg-red-300 px-4 py-2 rounded'
        @options = prepare(options:)
      end

      private

      def prepare(options:)
        options.reduce({}) do |hash, (key, value)|
          case key
          when :method, :confirm
            hash.deep_merge data: { "turbo_#{key}".to_sym => value }
          else
            hash.merge key => value
          end
        end
      end
    end
  end
end
