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
            'rounded-tl-md bg-zinc-900 text-zinc-50'
          when :right
            'rounded-tr-md bg-zinc-800 text-zinc-50'
          end
        end
      end
    end
  end
end
