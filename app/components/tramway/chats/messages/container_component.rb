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
          case position.to_sym
          when :left
            %w[items-start]
          when :right
            %w[items-end]
          end.join(' ')
        end

        def color_classes
          case position.to_sym
          when :left
            %w[bg-gray-800 rounded-tl-md]
          when :right
            %w[bg-blue-600 rounded-tr-md]
          end.join(' ')
        end
      end
    end
  end
end
