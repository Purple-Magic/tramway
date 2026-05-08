# frozen_string_literal: true

module Tramway
  # Navbar component
  class NavbarComponent < TailwindComponent
    NAVBAR_CLASSES = %w[
      flex items-center justify-between border-zinc-800 px-4 py-3 shadow-sm backdrop-blur sm:px-6
    ].freeze

    MOBILE_BUTTON_CLASSES = %w[
      inline-flex items-center justify-center rounded-md p-2 transition-colors hover:bg-zinc-800 hover:text-zinc-50
      focus:outline-none focus-visible:ring-2 focus-visible:ring-zinc-400 focus-visible:ring-offset-2
      focus-visible:ring-offset-zinc-950
    ].freeze

    MOBILE_MENU_CLASSES = %w[
      fixed inset-0 z-50 hidden h-screen w-screen flex-col border-r border-zinc-800 bg-zinc-950 px-4 py-6 shadow-lg
      transition-transform transform -translate-x-full duration-300 ease-in-out pt-16
    ].freeze

    def initialize(**options)
      @title = { text: options[:title], link: options[:title_link] || '/' }
      @left_items = options[:left_items]
      @right_items = options[:right_items]
    end

    def navbar_classes
      NAVBAR_CLASSES.join(' ')
    end

    def title_classes
      'text-base font-semibold text-zinc-50'
    end

    def mobile_button_classes
      MOBILE_BUTTON_CLASSES.join(' ')
    end

    def mobile_menu_classes
      MOBILE_MENU_CLASSES.join(' ')
    end
  end
end
