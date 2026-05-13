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
      (base_wrapper_classes + event_wrapper_classes + options[:class].to_s.split).compact.join(' ')
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

    def event_wrapper_classes
      return %w[group] if normalized_event == :hover

      %w[cursor-pointer]
    end

    def base_tooltip_classes
      %w[
        absolute bottom-full left-1/2 z-50 mb-2 w-max max-w-xs -translate-x-1/2 rounded-md border
        border-zinc-800 bg-zinc-950 px-2.5 py-1.5 text-xs font-medium leading-5 text-zinc-50 shadow-lg
      ]
    end

    def event_tooltip_classes
      if normalized_event == :hover
        return %w[pointer-events-none invisible opacity-0 transition-opacity group-hover:visible
                  group-hover:opacity-100]
      end

      %w[open:block hidden]
    end
  end
end
