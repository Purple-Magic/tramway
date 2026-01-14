# frozen_string_literal: true

module Tailwinds
  # Description: A Tailwinds flash message component for displaying notifications.
  class FlashComponent < Tailwinds::BaseComponent
    option :text
    option :type, optional: true, default: -> {}
    option :color, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }

    def container_classes
      theme_classes(
        classic: 'fixed top-4 right-4 z-50 space-y-2'
      )
    end

    def flash_classes
      theme_classes(
        classic: "flash opacity-100 px-4 py-2 rounded-xl shadow-md bg-#{resolved_color}-100 " \
                 "text-#{resolved_color}-800 dark:bg-#{resolved_color}-900 dark:text-#{resolved_color}-100"
      )
    end

    def title_classes
      theme_classes(
        classic: 'text-xl font-semibold'
      )
    end
  end
end
