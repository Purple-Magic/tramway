# frozen_string_literal: true

module Tailwinds
  # Default Tramway badge
  #
  class BadgeComponent < Tailwinds::BaseComponent
    option :text
    option :type, optional: true
    option :color, optional: true

    def classes
      theme_classes(
        classic: [
          'flex', 'px-3', 'py-1', 'text-sm', 'font-semibold', 'rounded-full', 'w-fit', 'h-fit',
          "bg-#{resolved_color}-200", "text-#{resolved_color}-800", 'shadow-md',
          "dark:bg-#{resolved_color}-700", "dark:text-#{resolved_color}-100"
        ]
      )
    end
  end
end
