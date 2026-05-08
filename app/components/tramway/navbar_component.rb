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
      [
        'flex',
        'items-center',
        'justify-between',
        'border-zinc-800',
        'px-4',
        'py-3',
        'shadow-sm',
        'backdrop-blur',
        'sm:px-6'
      ].join(' ')
    end

    def title_classes
      'text-base font-semibold text-zinc-50'
    end

    def mobile_button_classes
      [
        'inline-flex',
        'items-center',
        'justify-center',
        'rounded-md',
        'p-2',
        'transition-colors',
        'hover:bg-zinc-800',
        'hover:text-zinc-50',
        'focus:outline-none',
        'focus-visible:ring-2',
        'focus-visible:ring-zinc-400',
        'focus-visible:ring-offset-2',
        'focus-visible:ring-offset-zinc-950'
      ].join(' ')
    end

    def mobile_menu_classes
      [
        'fixed',
        'inset-0',
        'z-50',
        'hidden',
        'h-screen',
        'w-screen',
        'flex-col',
        'border-r',
        'border-zinc-800',
        'bg-zinc-950',
        'px-4',
        'py-6',
        'shadow-lg',
        'transition-transform',
        'transform',
        '-translate-x-full',
        'duration-300',
        'ease-in-out',
        'pt-16'
      ].join(' ')
    end
  end
end
