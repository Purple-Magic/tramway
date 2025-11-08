# frozen_string_literal: true

module Tailwinds
  # Default Tramway badge
  #
  class BadgeComponent < Tailwinds::BaseComponent
    option :text
    option :type, optional: true
    option :color, optional: true

    def classes
      [
        'flex', 'px-3', 'py-1', 'text-sm', 'font-semibold', 'text-white', "bg-#{resolved_color}-500",
        "dark:bg-#{resolved_color}-600", 'rounded-full', 'w-fit', 'h-fit'
      ]
    end
  end
end
