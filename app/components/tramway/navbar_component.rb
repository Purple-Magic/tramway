# frozen_string_literal: true

module Tramway
  VERTICAL_NAVBAR_STYLES = <<~CSS
    @media (min-width: 768px) {
      body {
        padding-left: 16rem;
        transition: padding-left 150ms ease;
      }

      body[data-tramway-navbar-collapsed='true'] {
        padding-left: 4rem;
      }

      #desktop-navbar {
        width: 16rem;
        overflow-y: auto;
        overflow-x: hidden;
        transition: width 150ms ease;
      }

      #desktop-navbar-collapse-button {
        align-self: flex-start;
        width: 2rem;
        height: 2rem;
        padding: 0;
      }

      #desktop-navbar[data-tramway-navbar-collapsed='true'] {
        width: 4rem;
        padding-left: 0.5rem;
        padding-right: 0.5rem;
      }

      #desktop-navbar[data-tramway-navbar-collapsed='true'] [data-tramway-navbar-content] {
        display: none;
      }

      #desktop-navbar [data-tramway-navbar-content] ul {
        width: 100%;
      }

      #desktop-navbar [data-tramway-navbar-content] li {
        width: 100%;
      }

      #desktop-navbar [data-tramway-navbar-content] li > a,
      #desktop-navbar [data-tramway-navbar-content] li > button {
        display: flex;
        width: 100%;
        box-sizing: border-box;
      }

      #desktop-navbar[data-tramway-navbar-collapsed='true'] [data-tramway-navbar-collapse-container] {
        right: auto;
        left: 50%;
        transform: translateX(-50%);
      }

      #desktop-navbar[data-tramway-navbar-collapsed='true'] [data-tramway-navbar-collapse-icon] {
        transform: rotate(180deg);
      }
    }
  CSS

  # Navbar component
  class NavbarComponent < TailwindComponent
    attr_reader :direction

    VERTICAL_NAVBAR_STYLES = ::Tramway::VERTICAL_NAVBAR_STYLES

    DIRECTIONS = %i[horizontal vertical].freeze

    NAVBAR_CLASSES = %w[
      flex items-center justify-between border-zinc-800 px-4 py-3 shadow-sm backdrop-blur sm:px-6
    ].freeze

    VERTICAL_NAVBAR_CLASSES = %w[
      md:fixed md:left-0 md:top-0 md:z-40 md:flex md:h-screen md:w-64 md:flex-col md:items-start md:justify-start
      md:border-r md:px-6 md:py-6
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
      @direction = normalize_direction(options[:direction])
    end

    def navbar_classes
      (NAVBAR_CLASSES + vertical_navbar_classes).join(' ')
    end

    def title_classes
      'text-base font-semibold text-zinc-50'
    end

    def horizontal?
      @direction == :horizontal
    end

    def vertical?
      @direction == :vertical
    end

    def mobile_button_classes
      MOBILE_BUTTON_CLASSES.join(' ')
    end

    def mobile_menu_classes
      MOBILE_MENU_CLASSES.join(' ')
    end

    def desktop_header_classes
      return 'flex md:justify-between w-full items-center relative min-h-8' if horizontal?

      'flex w-full items-start gap-4 md:hidden'
    end

    def desktop_sidebar_classes
      'hidden md:relative md:flex md:h-full md:flex-1 md:flex-col md:items-stretch md:gap-4 md:pb-12'
    end

    def left_items_classes
      horizontal? ? 'flex-row items-center space-x-4 ml-4 hidden md:flex' : 'flex flex-col items-start gap-4 pt-4'
    end

    def right_items_classes
      horizontal? ? 'items-center space-x-4 hidden md:flex' : 'flex flex-col items-start gap-4 pt-4'
    end

    private

    def normalize_direction(direction)
      normalized_direction = direction.to_s.presence&.to_sym
      DIRECTIONS.include?(normalized_direction) ? normalized_direction : :vertical
    end

    def vertical_navbar_classes
      return [] unless vertical?

      VERTICAL_NAVBAR_CLASSES
    end
  end
end
