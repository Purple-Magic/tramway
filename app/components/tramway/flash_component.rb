# frozen_string_literal: true

module Tramway
  # Description: A Tramway flash message component for displaying notifications.
  class FlashComponent < Tramway::BaseComponent
    option :text
    option :type, optional: true, default: -> {}
    option :color, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }

    include Tramway::ColorsMethods

    def container_classes
      'tramway-flash-container'
    end

    def flash_classes
      (base_flash_classes + semantic_flash_classes).join(' ')
    end

    def title_classes
      'tramway-flash__text'
    end

    private

    def base_flash_classes
      %w[flash tramway-flash]
    end

    def semantic_flash_classes
      variant_classes('tramway-flash')
    end
  end
end
