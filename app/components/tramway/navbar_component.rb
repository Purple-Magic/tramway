# frozen_string_literal: true

module Tramway
  # Navbar component
  class NavbarComponent < TailwindComponent
    def initialize(**options)
      @title = { text: options[:title], link: options[:title_link] || '/' }
      @left_items = options[:left_items]
      @right_items = options[:right_items]
    end

    def navbar_classes
      theme_classes(
        classic: 'py-3 px-4 sm:px-8 flex justify-between items-center border-b border-zinc-800 bg-zinc-950'
      )
    end

    def title_classes
      theme_classes(
        classic: 'text-xl font-semibold text-zinc-100'
      )
    end

    def mobile_button_classes
      theme_classes(
        classic: 'text-zinc-200 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300'
      )
    end

    def mobile_menu_classes
      theme_classes(
        classic: [
          'hidden', 'inset-0', 'flex-col', 'bg-zinc-950', 'shadow-lg', 'h-screen', 'fixed', 'z-50', 'w-screen',
          'transition-transform', 'transform', '-translate-x-full', 'duration-300', 'ease-in-out', 'pt-16'
        ].join(' ')
      )
    end
  end
end
