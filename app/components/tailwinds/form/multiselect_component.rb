# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled multi-select field
    class MultiselectComponent < TailwindComponent
      option :collection

      def before_render
        @collection = collection.map do |(text, value)|
          { text:, value: }
        end.to_json
      end

      def multiselect_hash
        {
          controller:, selected_item_template:, multiselect_selected_items_value:, dropdown_container:, item_container:,
          items:, action:, select_as_input:, placeholder:, value:
        }.transform_keys { |key| key.to_s.gsub('_', '-') }
      end

      private

      def controller
        :multiselect
      end

      def action
        'click->multiselect#toggleDropdown'
      end

      def items
        collection
      end

      def placeholder
        @options[:placeholder]
      end

      def multiselect_selected_items_value
        []
      end

      def select_as_input
        render(Tailwinds::Form::Multiselect::SelectAsInput.new(options:, attribute:, input:))
      end

      def method_missing(method_name, *, &)
        component_name = "Tailwinds::Form::Multiselect::#{method_name.to_s.camelize}"

        if method_name.to_s.include?('_') && Object.const_defined?(component_name)
          render(component_name.constantize.new(*, &))
        else
          super
        end
      end
    end
  end
end
