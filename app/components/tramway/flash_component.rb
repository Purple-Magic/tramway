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
      theme_classes(
        classic: 'fixed top-4 right-4 z-50 w-full max-w-sm space-y-2 pointer-events-none'
      )
    end

    def flash_classes
      theme_classes(
        classic: "flash relative w-full rounded-lg border bg-zinc-950 px-4 py-3 text-sm shadow-sm " \
                 "#{shadcn_alert_variant_classes}"
      )
    end

    def title_classes
      theme_classes(
        classic: 'font-medium leading-none tracking-tight'
      )
    end
  end
end
