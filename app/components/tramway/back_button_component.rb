# frozen_string_literal: true

module Tramway
  # Backbutton component
  class BackButtonComponent < BaseComponent
    def back_button_classes
      theme_classes(
        classic: 'inline-flex h-9 items-center justify-center rounded-md border border-zinc-800 bg-zinc-950 px-4 py-2 ' \
                 'text-sm font-medium text-zinc-200 shadow-sm transition-colors hover:bg-zinc-800 ' \
                 'focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300 ml-2'
      )
    end
  end
end
