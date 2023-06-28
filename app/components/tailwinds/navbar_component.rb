# frozen_string_literal: true

module Tailwinds
  # Background helper module
  #
  module BackgroundHelper
    CSS_COLORS = %i[aqua black blue fuchsia gray green lime maroon navy olive orange purple red
                    silver teal white yellow].freeze
    MIN_INTENSITY = 100
    MAX_INTENSITY = 950
    DEFAULT_BACKGROUND_COLOR = :purple
    DEFAULT_BACKGROUND_INTENSITY = 700

    def self.background(options)
      color = options.dig(:background, :color) || DEFAULT_BACKGROUND_COLOR
      intensity = options.dig(:background, :intensity) || DEFAULT_BACKGROUND_INTENSITY

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

  # Navbar class main class
  #
  class NavbarComponent < TailwindComponent
    include Tailwinds::BackgroundHelper

    def initialize(**options)
      @title = { text: options[:title], link: options[:title_link] || '/' }
      @left_items = options[:left_items]
      @right_items = options[:right_items]
      @color = BackgroundHelper.background(options)
    end
  end
end
