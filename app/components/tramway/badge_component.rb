# frozen_string_literal: true

module Tramway
  # Default Tramway badge
  #
  class BadgeComponent < Tramway::BaseComponent
    option :text
    option :type, optional: true
    option :color, optional: true

    include Tramway::ColorsMethods

    def classes
      theme_classes(
        classic: [
          'inline-flex', 'items-center', 'rounded-md', 'px-2.5', 'py-0.5', 'text-xs', 'font-semibold',
          'transition-colors', 'focus:outline-none', 'focus:ring-2', 'focus:ring-zinc-950', 'focus:ring-offset-2',
          'w-fit', 'h-fit', *shadcn_badge_variant_classes.split
        ]
      )
    end
  end
end
