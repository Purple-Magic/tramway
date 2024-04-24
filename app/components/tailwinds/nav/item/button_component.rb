# frozen_string_literal: true

require 'rules/turbo_html_attributes_rules'

module Tailwinds
  module Nav
    # Render button styled with Tailwind using button_to or link_to methods
    #
    module Item
      class ButtonComponent < TailwindComponent
        def initialize(**options)
          @href = options[:href]
          @method = options[:method]
          @style = 'text-white hover:bg-red-300 px-4 py-2 rounded'
          @options = options.except(:href, :method)
        end
      end
    end
  end
end
