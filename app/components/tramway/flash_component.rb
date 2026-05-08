# frozen_string_literal: true

module Tramway
  # Description: A Tramway flash message component for displaying notifications.
  class FlashComponent < Tramway::BaseComponent
    option :text
    option :type, optional: true, default: -> {}
    option :color, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }

    include Tramway::ColorsMethods

    def container_classes
      'fixed top-4 right-4 z-50 flex w-fit max-w-sm flex-col gap-2 pointer-events-none'
    end

    def flash_classes
      (base_flash_classes + semantic_flash_classes).join(' ')
    end

    def title_classes
      'text-sm font-medium leading-6'
    end

    private

    def base_flash_classes
      %w[
        flash pointer-events-auto opacity-100 rounded-md border bg-zinc-950 px-4 py-3 text-sm text-zinc-50
        shadow-lg
      ]
    end

    def semantic_flash_classes
      {
        green: %w[border-green-800 text-green-400],
        blue: %w[border-blue-800 text-blue-400],
        orange: %w[border-orange-800 text-orange-400],
        red: %w[border-red-800 text-red-400],
        violet: %w[border-violet-800 text-violet-400],
        indigo: %w[border-indigo-800 text-indigo-400],
        yellow: %w[border-yellow-800 text-yellow-400],
        zinc: %w[border-zinc-800 text-zinc-50]
      }.fetch(resolved_color.to_sym, %w[border-zinc-800 text-zinc-50])
    end
  end
end
