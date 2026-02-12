# frozen_string_literal: true

module Tramway
  module Chats
    module Broadcast
      MESSAGE_TYPES = %i[sent received].freeze

      def tramway_chat_append_message(chat_id:, message_type:, text:, sent_at:)
        raise ArgumentError, 'message_type must be :sent or :received' unless MESSAGE_TYPES.include?(message_type.to_sym)

        type = message_type
        args = [
          [chat_id, 'messages'],
          {
            target: 'messages',
            partial: 'tramway/chats/message',
            locals: { type:, text:, sent_at: }
          }
        ]

        if respond_to?(:broadcast_append_to)
          broadcast_append_to(*args)
        else
          Turbo::StreamsChannel.broadcast_append_to(*args)
        end
      end
    end
  end
end
