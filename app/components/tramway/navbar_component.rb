# frozen_string_literal: true

module Tramway
  # Navbar component
  class NavbarComponent < TailwindComponent
    NAVBAR_BASE_CLASSES = %w[
      bg-zinc-950 text-zinc-50
    ].freeze

    HORIZONTAL_NAVBAR_CLASSES = %w[
      flex items-center justify-between border-zinc-800 px-4 py-3 shadow-sm backdrop-blur sm:px-6
    ].freeze

    VERTICAL_NAVBAR_CLASSES = %w[
      flex flex-col border-zinc-800 px-4 py-3 shadow-sm backdrop-blur sm:px-6
    ].freeze

    VERTICAL_DESKTOP_NAVBAR_CLASSES = %w[
      md:fixed md:left-0 md:top-0 md:z-40 md:h-dvh md:w-72 md:flex-col md:border-r md:border-zinc-800
      md:bg-zinc-950 md:px-4 md:py-3 md:shadow-sm md:backdrop-blur md:overflow-hidden md:transition-[width]
      md:duration-300 md:ease-in-out-strong md:motion-reduce:duration-0
    ].freeze

    MOBILE_BUTTON_CLASSES = %w[
      inline-flex items-center justify-center rounded-md p-2 transition-colors hover:bg-zinc-800 hover:text-zinc-50
      focus:outline-none focus-visible:ring-2 focus-visible:ring-zinc-400 focus-visible:ring-offset-2
      focus-visible:ring-offset-zinc-950
    ].freeze

    MOBILE_MENU_CLASSES = %w[
      fixed inset-0 z-50 hidden h-screen w-screen flex flex-col border-r border-zinc-800 bg-zinc-950 px-4 py-6 shadow-lg
      transition-transform transform -translate-x-full duration-300 ease-in-out pt-16 justify-between
    ].freeze

    def initialize(**options)
      @title = { text: options[:title], link: options[:title_link] || '/' }
      @left_items = options[:left_items]
      @right_items = options[:right_items]
      @direction = options[:direction].presence&.to_sym || :vertical
    end

    def navbar_classes
      classes = NAVBAR_BASE_CLASSES.dup
      classes.concat(HORIZONTAL_NAVBAR_CLASSES) if horizontal?
      classes.concat(VERTICAL_NAVBAR_CLASSES + VERTICAL_DESKTOP_NAVBAR_CLASSES) if vertical?

      classes.join(' ')
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

    def mobile_horizontal_container_classes
      "#{HORIZONTAL_NAVBAR_CLASSES.join(' ')} md:hidden"
    end

    def horizontal?
      @direction == :horizontal
    end

    def vertical?
      @direction == :vertical
    end

    def direction
      @direction.to_s
    end

    def desktop_vertical_container_classes
      'hidden md:flex tramway-navbar-desktop-vertical h-full w-full flex-col overflow-hidden'
    end

    def desktop_vertical_header_classes
      [
        'tramway-navbar-desktop-vertical-header flex w-full items-center justify-between overflow-hidden',
        'transition-opacity duration-300 ease-out-strong'
      ].join(' ')
    end

    def desktop_vertical_content_classes
      [
        'tramway-navbar-desktop-vertical-content flex w-full flex-1 flex-col gap-3 overflow-y-auto overflow-hidden',
        'transition-opacity duration-300 ease-out-strong'
      ].join(' ')
    end

    def desktop_vertical_item_list_classes
      'tramway-navbar-desktop-vertical-list mt-8 flex w-full flex-col gap-1'
    end

    def desktop_vertical_toggle_wrapper_classes(expanded: true)
      base = 'mt-auto flex w-full'
      expanded ? "#{base} justify-start" : "#{base} justify-end"
    end

    def desktop_vertical_toggle_button_classes
      [
        'inline-flex cursor-pointer items-center justify-center rounded-md px-4 py-3 transition-colors',
        'hover:bg-zinc-800 hover:text-zinc-50',
        'focus:outline-none focus-visible:ring-2 focus-visible:ring-zinc-400 focus-visible:ring-offset-2',
        'focus-visible:ring-offset-zinc-950 w-fit'
      ].join(' ')
    end

    def desktop_vertical_toggle_button_label(expanded:)
      expanded ? 'Collapse sidebar' : 'Expand sidebar'
    end

    def desktop_vertical_toggle_icon_classes(expanded:)
      classes = %w[fa fa-chevron-left transition-transform duration-200 ease-in-out-strong motion-reduce:duration-0]
      classes << 'rotate-180' unless expanded

      classes.join(' ')
    end
  end
end
