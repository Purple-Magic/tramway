# frozen_string_literal: true

module Tramway
  # Color logic implementation
  module ColorsMethods
    TYPE_COLOR_MAP = {
      default: :zinc,
      inverse: :zinc,
      life: :zinc,
      primary: :blue,
      hope: :blue,
      secondary: :zinc,
      success: :green,
      will: :green,
      warning: :orange,
      greed: :orange,
      danger: :red,
      rage: :red,
      love: :violet,
      compassion: :indigo,
      fear: :yellow,
      submit: :green
    }.freeze

    # Every type keeps working; each one is rendered with one of the design system variants.
    # `love`, `compassion` and `fear` have no dedicated variant: `love` (violet) uses the accent,
    # `compassion` (indigo, used for cancel-like actions) the neutral surface and `fear` (yellow) the warning one.
    # `submit` is the solid green call to action of a form.
    TYPE_VARIANT_MAP = {
      default: :secondary,
      inverse: :ghost,
      life: :secondary,
      primary: :primary,
      hope: :primary,
      secondary: :secondary,
      success: :success,
      will: :success,
      warning: :warning,
      greed: :warning,
      danger: :danger,
      rage: :danger,
      love: :primary,
      compassion: :secondary,
      fear: :warning,
      submit: :submit
    }.freeze

    # Tailwind color names that can be used as an explicit `color:`; they have a `.tramway-tint--*` class.
    TINT_COLORS = %w[
      red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose
      slate gray zinc neutral stone
    ].freeze

    def resolved_color
      (color || type_color).to_s
    end

    def type_color
      TYPE_COLOR_MAP.fetch(normalized_type, TYPE_COLOR_MAP[:default]).to_sym
    end

    # Design system variant (`primary`, `secondary`, `ghost`, `success`, `warning`, `danger`) for the type.
    def variant
      key = color.present? ? color.to_s.downcase.to_sym : normalized_type

      TYPE_VARIANT_MAP.fetch(key, TYPE_VARIANT_MAP.fetch(:default))
    end

    # CSS classes for the given primitive (e.g. `tramway-button`): a fixed variant class, or the tinted
    # fallback driven by `currentColor` when `color:` is a Tailwind color name instead of a Tramway type.
    def variant_classes(base)
      return ["#{base}--#{variant}"] unless tinted?

      ["#{base}--tint", ("tramway-tint--#{color}" if TINT_COLORS.include?(color.to_s))].compact
    end

    def tinted?
      color.present? && !TYPE_VARIANT_MAP.key?(color.to_s.downcase.to_sym)
    end

    def normalized_type
      value = type
      value = nil if value.respond_to?(:empty?) && value.empty?
      value ||= :default
      value = value.downcase if value.respond_to?(:downcase)
      value = value.to_sym if value.respond_to?(:to_sym)

      TYPE_COLOR_MAP.key?(value) ? value : :default
    end
  end
end
