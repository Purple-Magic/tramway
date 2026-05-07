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
            %w[border border-zinc-800 bg-zinc-950 text-zinc-200]
          when :right
            %w[bg-zinc-50 text-zinc-950]
          end.join(' ')
        end
      end
    end
  end
end
