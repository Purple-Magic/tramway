# frozen_string_literal: true

module Tailwinds
  # Navbar class main class
  #
  class NavbarComponent < TailwindComponent
    def initialize(**options)
      @title = options[:title]
      @left_items = options[:left_items]
      @right_items = options[:right_items]
    end
  end
end
