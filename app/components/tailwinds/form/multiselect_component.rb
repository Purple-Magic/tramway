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
          items:, action:, select_as_input:, placeholder:, value:, on_change:
        }.transform_keys { |key| key.to_s.gsub('_', '-') }
      end

      def controller
        controllers = [:multiselect]
        controllers << external_action.split('->').last.split('#').first if external_action
        controllers += external_controllers
        controllers.join(' ')
      end

      def wrapper_classes
        theme_classes(
          classic: 'flex flex-col relative text-gray-100',
          neomorphism: 'flex flex-col relative text-gray-700 dark:text-gray-200'
        )
      end

      def dropdown_classes
        theme_classes(
          classic: 'p-1 flex border rounded border-gray-600 bg-gray-800',
          neomorphism: 'p-1 flex border rounded-xl border-gray-200 bg-gray-100 shadow-inner ' \
                       'dark:bg-gray-900 dark:border-gray-700'
        )
      end

      def dropdown_indicator_classes
        theme_classes(
          classic: 'w-8 py-1 pl-2 pr-1 border-l flex items-center text-gray-500 border-gray-600',
          neomorphism: 'w-8 py-1 pl-2 pr-1 border-l flex items-center text-gray-400 border-gray-200 ' \
                       'dark:text-gray-500 dark:border-gray-700'
        )
      end

      private

      def action
        'click->multiselect#toggleDropdown'
      end

      def items
        collection
      end

      def placeholder
        options[:placeholder]
      end

      def multiselect_selected_items_value
        []
      end

      def select_as_input
        render(
          Tailwinds::Form::Multiselect::SelectAsInput.new(
            options:,
            attribute:,
            input:,
            size_class: size_class(:multiselect_input)
          )
        )
      end

      def on_change
        return unless external_action&.start_with?('change')

        external_action.split('->').last
      end

      def external_controllers
        options[:controller]&.split || []
      end

      def external_action
        options.dig(:data, :action)
      end

      def method_missing(method_name, *, &)
        component = component_name(method_name)

        if method_name.to_s.include?('_') && Object.const_defined?(component)
          render(component.constantize.new(*, &))
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        if method_name.to_s.include?('_') && Object.const_defined?(component_name(method_name))
          true
        else
          super
        end
      end

      # :reek:UtilityFunction { enabled: false }
      def component_name(method_name)
        "Tailwinds::Form::Multiselect::#{method_name.to_s.camelize}"
      end
      # :reek:UtilityFunction { enabled: true }
    end
  end
end
