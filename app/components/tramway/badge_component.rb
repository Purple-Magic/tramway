# frozen_string_literal: true

module Tramway
  # Default Tramway badge
  #
  class BadgeComponent < Tramway::BaseComponent
    DEFAULT_BADGE_CLASSES = %w[tramway-badge].freeze

    option :text
    option :type, optional: true
    option :color, optional: true

    include Tramway::ColorsMethods

    def classes
      (DEFAULT_BADGE_CLASSES + color_classes).join(' ')
    end

    def color_classes
      variant_classes('tramway-badge')
    end
  end
end
