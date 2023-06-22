# frozen_string_literal: true

module Tailwinds
  # Navbar class main class
  #
  class NavbarComponent < TailwindComponent
    def initialize(**options)
      @title = options[:title]
      @left_items = options[:left_items]
      @right_items = options[:right_items]
      @color = background(options)
    end

    private

    CSS_COLORS = %i[aqua black blue fuchsia gray green lime maroon navy olive orange purple red
                    silver teal white yellow].freeze
    MIN_INTENSITY = 100
    MAX_INTENSITY = 950

    def background(options)
      color = options.dig(:background, :color) || :purple
      intensity = options.dig(:background, :intensity) || 700

      unless (MIN_INTENSITY..MAX_INTENSITY).cover?(intensity)
        raise "Navigation Background Color intensity should be between #{MIN_INTENSITY} and #{MAX_INTENSITY}"
      end

      if color.in? CSS_COLORS
        "#{color}-#{intensity}"
      else
        "[#{color}]"
      end
    end
  end
end
