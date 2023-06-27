# frozen_string_literal: true

module Rules
  # Provides rules for turbo html attributes
  # It allows users to :method and :confirm attributes instead of data-turbo_method and data-turbo_confirm
  module TurboHtmlAttributesRules
    def prepare_turbo_html_attributes(options:)
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
