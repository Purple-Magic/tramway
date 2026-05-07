# frozen_string_literal: true

module Tramway
  # Title component
  class TitleComponent < Tramway::BaseComponent
    option :text
    option :options, optional: true, default: -> { {} }

    def title_classes
      theme_classes(
        classic: "scroll-m-20 text-2xl font-semibold tracking-tight text-zinc-100 #{options[:class]}"
      )
    end
  end
end
