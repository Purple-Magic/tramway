# frozen_string_literal: true

module Tailwinds
  # Navbar component
  class NavbarComponent < TailwindComponent
    def initialize(**options)
      @title = { text: options[:title], link: options[:title_link] || '/' }
      @left_items = options[:left_items]
      @right_items = options[:right_items]
    end
  end
end
