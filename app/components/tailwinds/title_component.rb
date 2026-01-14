# frozen_string_literal: true

module Tailwinds
  # Title component
  class TitleComponent < Tramway::BaseComponent
    option :text

    def title_classes
      theme_classes(
        classic: 'font-semibold text-2xl md:text-4xl text-gray-100'
      )
    end
  end
end
