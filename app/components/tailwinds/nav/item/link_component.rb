# frozen_string_literal: true

require 'rules/turbo_html_attributes_rules'

module Tailwinds
  module Nav
    module Item
      # Render button styled with Tailwind using link_to methods
      #
      class LinkComponent < Tailwinds::Nav::ItemComponent
        def initialize(**options)
          @href = options[:href]
          @options = Rules::TurboHtmlAttributesRules.prepare_turbo_html_attributes(options:)
        end
      end
    end
  end
end
