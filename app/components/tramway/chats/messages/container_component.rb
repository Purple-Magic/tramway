# frozen_string_literal: true

module Tramway
  module Chats
    module Messages
      # Renders a message container with alignment and color styles.
      class ContainerComponent < Tramway::BaseComponent
        option :position
        option :text
        option :sent_at

        def position_classes
          position.to_sym == :left ? 'items-start' : 'items-end'
        end

        def color_classes
          case position.to_sym
          when :left
            'tramway-chat__bubble--received'
          when :right
            'tramway-chat__bubble--sent'
          end
        end
      end
    end
  end
end
