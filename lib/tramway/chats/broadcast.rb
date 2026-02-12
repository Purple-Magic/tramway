# frozen_string_literal: true

module Tramway
  module Chats
    module Broadcast
      MESSAGE_TYPES = %i[sent received].freeze

      def append_message(message_type:, text:, sent_at:)
        raise ArgumentError, 'message_type must be :sent or :received' unless MESSAGE_TYPES.include?(message_type.to_sym)

        type = message_type

        broadcast_append_to(
          [chat.user.id, 'messages'],
          target: 'messages',
          partial: 'tramway/chats/message',
          locals: { type:, text:, sent_at: }
        )
      end
    end
  end
end
