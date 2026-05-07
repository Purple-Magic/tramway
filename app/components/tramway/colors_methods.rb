# frozen_string_literal: true

module Tramway
  # Color logic implementation
  module ColorsMethods
    TYPE_COLOR_MAP = {
      default: :gray,
      life: :gray,
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
      compassio: :indigo,
      fear: :yellow,
      submit: :green
    }.freeze

    SHADCN_BUTTON_VARIANT_CLASSES = {
      gray: 'border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm hover:bg-zinc-800',
      blue: 'bg-zinc-50 text-zinc-950 shadow-sm hover:bg-zinc-200',
      green: 'bg-zinc-50 text-zinc-950 shadow-sm hover:bg-zinc-200',
      red: 'bg-red-600 text-white shadow-sm hover:bg-red-600/90',
      orange: 'border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm hover:bg-zinc-800',
      zinc: 'border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm hover:bg-zinc-800',
      violet: 'bg-zinc-50 text-zinc-950 shadow-sm hover:bg-zinc-200',
      indigo: 'bg-zinc-50 text-zinc-950 shadow-sm hover:bg-zinc-200',
      yellow: 'border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm hover:bg-zinc-800'
    }.freeze

    SHADCN_BADGE_VARIANT_CLASSES = {
      gray: 'border border-transparent bg-zinc-50 text-zinc-950',
      blue: 'border border-transparent bg-zinc-50 text-zinc-950',
      green: 'border border-transparent bg-zinc-50 text-zinc-950',
      red: 'border border-transparent bg-red-600 text-white',
      orange: 'border border-zinc-800 text-zinc-200',
      zinc: 'border border-zinc-800 text-zinc-200',
      violet: 'border border-transparent bg-zinc-50 text-zinc-950',
      indigo: 'border border-transparent bg-zinc-50 text-zinc-950',
      yellow: 'border border-zinc-800 text-zinc-200'
    }.freeze

    SHADCN_ALERT_VARIANT_CLASSES = {
      gray: 'border-zinc-800 text-zinc-200',
      blue: 'border-zinc-800 text-zinc-200',
      green: 'border-zinc-800 text-zinc-200',
      red: 'border-red-500/50 text-red-400',
      orange: 'border-zinc-800 text-zinc-200',
      zinc: 'border-zinc-800 text-zinc-200',
      violet: 'border-zinc-800 text-zinc-200',
      indigo: 'border-zinc-800 text-zinc-200',
      yellow: 'border-zinc-800 text-zinc-200'
    }.freeze

    def resolved_color
      (color || type_color).to_s
    end

    def type_color
      TYPE_COLOR_MAP.fetch(normalized_type, TYPE_COLOR_MAP[:default]).to_sym
    end

    def shadcn_button_variant_classes
      SHADCN_BUTTON_VARIANT_CLASSES.fetch(resolved_color.to_sym, SHADCN_BUTTON_VARIANT_CLASSES[:gray])
    end

    def shadcn_badge_variant_classes
      SHADCN_BADGE_VARIANT_CLASSES.fetch(resolved_color.to_sym, SHADCN_BADGE_VARIANT_CLASSES[:gray])
    end

    def shadcn_alert_variant_classes
      SHADCN_ALERT_VARIANT_CLASSES.fetch(resolved_color.to_sym, SHADCN_ALERT_VARIANT_CLASSES[:gray])
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
