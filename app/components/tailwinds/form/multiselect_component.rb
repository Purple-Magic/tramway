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
          controller: :multiselect,
          "selected-item-template": render(Tailwinds::Form::Multiselect::SelectedItemTemplate.new),
          "multiselect-selected-items-value" => [],
          "dropdown-container": render(Tailwinds::Form::Multiselect::DropdownContainer.new),
          "item-container": render(Tailwinds::Form::Multiselect::ItemContainer.new),
          items: @collection,
          action: "click->multiselect#toggleDropdown",
          "select-as-input": render(Tailwinds::Form::Multiselect::SelectAsInputComponent.new(options:, attribute:, input:)),
          placeholder: "Select an option",
        }
      end
    end
  end
end
