# frozen_string_literal: true

module Tailwinds
  # Default Tramway button
  #
  class ButtonComponent < BaseComponent
    option :text, optional: true, default: -> {}
    option :path, optional: true, default: -> { '#' }
    option :color, optional: true
    option :type, optional: true
    option :size, default: -> { :middle }
    option :method, optional: true, default: -> { :get }
    option :link, optional: true, default: -> { false }
    option :options, optional: true, default: -> { {} }

    def size_classes
      {
        small: 'text-sm py-1 px-2 rounded',
        middle: 'py-2 px-4',
        large: 'text-lg px-5 py-3'
      }[size]
    end

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

    def classes
      (default_classes +
        light_mode_classes +
        dark_mode_classes +
        (link ? %w[px-1 h-fit] : ['cursor-pointer'])).compact.join(' ')
    end

    def default_classes
      [
        'btn',
        'btn-primary',
        'font-bold',
        'rounded-sm',
        'flex',
        'flex-row',
        size_classes.to_s,
        options[:class].to_s
      ]
    end

    def light_mode_classes
      [
        "bg-#{resolved_color}-500",
        "hover:bg-#{resolved_color}-700",
        'text-white'
      ]
    end

    def dark_mode_classes
      [
        "dark:bg-#{resolved_color}-600",
        "dark:hover:bg-#{resolved_color}-800",
        'dark:text-gray-300'
      ]
    end

    private

    def resolved_color
      (color || type_color).to_s
    end

    def type_color
      TYPE_COLOR_MAP.fetch(normalized_type, TYPE_COLOR_MAP[:default]).to_sym
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
