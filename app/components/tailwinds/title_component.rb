# frozen_string_literal: true

module Tailwinds
  # Title component
  class TitleComponent < Tramway::BaseComponent
    option :text

    def title_classes
      theme_classes(
        classic: 'font-bold text-4xl text-white',
        neomorphism: 'font-semibold text-4xl text-gray-800 dark:text-gray-100'
      )
    end
  end
end
