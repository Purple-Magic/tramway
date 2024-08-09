# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled multi-select field
    class MultiselectComponent < TailwindComponent
      option :collection

      def before_render
        @collection = collection.map do |(value, text)|
          { value:, text: }
        end.to_json
      end
    end
  end
end
