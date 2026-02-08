# frozen_string_literal: true

module Tramway
  # Title component
  class TitleComponent < Tramway::BaseComponent
    option :text
    option :options, optional: true, default: -> { {} }

    def title_classes
      theme_classes(
        classic: "font-semibold text-2xl md:text-4xl text-gray-100 #{options[:class]}"
      )
    end
  end
end
