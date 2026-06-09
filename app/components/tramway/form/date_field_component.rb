# frozen_string_literal: true

module Tramway
  module Form
    # Tailwind-styled date field
    class DateFieldComponent < TailwindComponent
      PICKER_ONCLICK = 'try { this.showPicker && this.showPicker() } catch (error) {}'

      private

      def picker_options(classes)
        @options.merge(class: classes, onclick: [@options[:onclick], PICKER_ONCLICK].compact.join('; '))
      end
    end
  end
end
