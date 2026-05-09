# frozen_string_literal: true

module Tramway
  # Default Tramway badge
  #
  class BadgeComponent < Tramway::BaseComponent
    DEFAULT_BADGE_CLASSES = %w[
      inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors
      focus:outline-none focus:ring-2 focus:ring-zinc-400 focus:ring-offset-2 focus:ring-offset-zinc-950
    ].freeze

    option :text
    option :type, optional: true
    option :color, optional: true

    include Tramway::ColorsMethods

    def classes
      (DEFAULT_BADGE_CLASSES + color_classes).join(' ')
    end

    def color_classes
      return accent_color_classes if color.present?

      mapped_color_classes || accent_color_classes
    end

    def mapped_color_classes
      {
        default: default_color_classes,
        life: default_color_classes,
        secondary: secondary_color_classes,
        inverse: inverse_color_classes
      }[normalized_type]
    end

    def default_color_classes
      %w[border-transparent bg-zinc-50 text-zinc-950 shadow hover:bg-zinc-200]
    end

    def secondary_color_classes
      %w[border-transparent bg-zinc-800 text-zinc-50 shadow hover:bg-zinc-800/80]
    end

    def inverse_color_classes
      %w[border-zinc-800 bg-zinc-950 text-zinc-50 shadow hover:bg-zinc-900]
    end

    def accent_color_classes
      [
        "border-#{resolved_color}-800",
        "bg-#{resolved_color}-900/30",
        "text-#{resolved_color}-400",
        "hover:bg-#{resolved_color}-900"
      ]
    end
  end
end
