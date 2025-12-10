# frozen_string_literal: true

module Tailwinds
  # Description: A Tailwinds flash message component for displaying notifications.
  class FlashComponent < Tailwinds::BaseComponent
    option :text
    option :type, optional: true, default: -> {}
    option :color, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }
  end
end
