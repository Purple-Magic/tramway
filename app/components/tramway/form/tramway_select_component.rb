# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled multi-select field
    class TramwaySelectComponent < TailwindComponent
      option :collection
      option :multiple, optional: true, default: -> { false }
      option :autocomplete, optional: true, default: -> { false }

      def before_render
        @collection = collection.map do |(text, value)|
          { text:, value: }
        end.to_json
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def tramway_select_hash
        default = {
          controller:,
          selected_item_template:,
          tramway_select_selected_items_value:,
          dropdown_container:,
          item_container:,
          items:,
          action:,
          select_as_input:,
          placeholder:,
          value:,
          on_change:,
          multiple: multiple.to_s,
          autocomplete: autocomplete.to_s
        }.transform_keys { |key| key.to_s.gsub('_', '-') }

        default.merge!(autocomplete_input:) if autocomplete

        default
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def autocomplete_input
        component 'tramway/form/tramway_select/autocomplete_input'
      end

      def tramway_select_classes
        classes = ''

        classes += 'select--multiple ' if multiple
        classes += 'select--autocomplete ' if autocomplete

        classes
      end

      def controller
        controllers = ['tramway-select']
        controllers << external_action.split('->').last.split('#').first if external_action
        controllers += external_controllers
        controllers.join(' ')
      end

      def dropdown_data
        (options[:data] || {}).merge(
          'tramway-select-target' => 'dropdown',
          'dropdown-container' => dropdown_container,
          'item-container' => item_container
        )
      end

      def dropdown_options
        options.except(:data).merge(class: input_classes)
      end

      def input_classes
        "#{size_class(:tramway_select_input)} #{select_base_classes}"
      end

      private

      def action
        'click->tramway-select#toggleDropdown'
      end

      def items
        collection
      end

      def placeholder
        options[:placeholder]
      end

      def tramway_select_selected_items_value
        []
      end

      def select_as_input
        component(
          'tramway/form/tramway_select/select_as_input',
          options:,
          attribute:,
          input:,
          size_class: size_class(:tramway_select_input)
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

      def selected_item_template
        component 'tramway/form/tramway_select/selected_item_template', size:, multiple:
      end

      def dropdown_container
        component('tramway/form/tramway_select/dropdown_container', size:)
      end

      def item_container
        component('tramway/form/tramway_select/item_container', size:)
      end
    end
  end
end
