# frozen_string_literal: true

require 'rules/turbo_html_attributes_rules'

module Tailwinds
  module Nav
    module Item
      # Render button styled with Tailwind using link_to methods
      #
      class LinkComponent < TailwindComponent
        def initialize(**options)
          @href = options[:href]
          @style = 'text-white hover:bg-red-300 px-4 py-2 rounded'
          @options = Rules::TurboHtmlAttributesRules.prepare_turbo_html_attributes(options:)
        end
      end
    end
  end
end
