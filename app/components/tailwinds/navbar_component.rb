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
        classic: 'py-2 px-4 sm:px-8 flex justify-between items-center bg-gray-900 shadow-md'
      )
    end

    def title_classes
      theme_classes(
        classic: 'text-xl font-semibold text-gray-100'
      )
    end

    def mobile_button_classes
      theme_classes(
        classic: 'text-gray-200 focus:outline-none'
      )
    end

    def mobile_menu_classes
      theme_classes(
        classic: 'hidden inset-0 flex-col bg-gray-900 shadow-inner h-screen fixed z-50 w-screen transition-transform transform -translate-x-full duration-300'
      )
    end
  end
end
