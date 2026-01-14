# frozen_string_literal: true

module Tailwinds
  # Navbar component
  class NavbarComponent < TailwindComponent
    def initialize(**options)
      @title = { text: options[:title], link: options[:title_link] || '/' }
      @left_items = options[:left_items]
      @right_items = options[:right_items]
    end

    def navbar_classes
      theme_classes(
        classic: 'py-2 px-4 sm:px-8 flex justify-between items-center bg-gray-100 shadow-md ' \
                 'dark:bg-gray-900'
      )
    end

    def title_classes
      theme_classes(
        classic: 'text-xl font-semibold text-gray-800 dark:text-gray-100'
      )
    end

    def mobile_button_classes
      theme_classes(
        classic: 'text-gray-700 focus:outline-none dark:text-gray-200'
      )
    end

    def mobile_menu_classes
      theme_classes(
        classic: 'hidden flex-col sm:hidden bg-gray-100 shadow-inner dark:bg-gray-900'
      )
    end
  end
end
