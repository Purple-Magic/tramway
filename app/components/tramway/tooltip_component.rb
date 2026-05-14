# frozen_string_literal: true

module Tramway
  # Default Tramway tooltip
  #
  class TooltipComponent < Tramway::BaseComponent
    EVENTS = %i[hover onclick].freeze

    option :text
    option :event, default: -> { :hover }
    option :options, optional: true, default: -> { {} }

    def wrapper_classes
      (base_wrapper_classes + options[:class].to_s.split).compact.join(' ')
    end

    def trigger_classes
      {
        hover: %w[peer inline-flex w-fit],
        onclick: %w[inline-flex w-fit cursor-pointer]
      }[normalized_event].join(' ')
    end

    def wrapper_data
      return options[:data] || {} unless normalized_event == :onclick

      (options[:data] || {}).merge(
        controller: merged_controller,
        action: merged_action
      )
    end

    def wrapper_options
      options.except(:class, :data).merge(data: wrapper_data)
    end

    def trigger_data
      return {} unless normalized_event == :onclick

      { action: 'click->tramway-tooltip#toggle' }
    end

    def tooltip_data
      return {} unless normalized_event == :onclick

      { 'tramway-tooltip-target': 'panel' }
    end

    def tooltip_classes
      (base_tooltip_classes + event_tooltip_classes).join(' ')
    end

    def normalized_event
      event.to_sym
    end

    private

    def before_render
      return if EVENTS.include?(normalized_event)

      raise ArgumentError, "Invalid event: #{event}. Valid events are :hover, :onclick."
    end

    def base_wrapper_classes
      %w[relative inline-flex w-fit]
    end

    def base_tooltip_classes
      %w[
        absolute bottom-full left-1/2 z-50 mb-2 w-max min-w-40 max-w-sm -translate-x-1/2 rounded-md border
        border-zinc-800 bg-zinc-950 px-2.5 py-1.5 text-xs font-medium leading-5 text-zinc-50 shadow-lg
      ]
    end

    def event_tooltip_classes
      if normalized_event == :hover
        return %w[pointer-events-none invisible opacity-0 transition-opacity peer-hover:visible
                  peer-hover:opacity-100]
      end

      %w[hidden]
    end

    def merged_controller
      [options.dig(:data, :controller), 'tramway-tooltip'].compact_blank.join(' ')
    end

    def merged_action
      [options.dig(:data, :action), 'click@window->tramway-tooltip#closeOnClickOutside'].compact_blank.join(' ')
    end
  end
end
