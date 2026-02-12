# frozen_string_literal: true

module Tramway
  module Chats
    # Broadcast helpers for appending chat messages via Turbo Streams.
    module Broadcast
      ALLOWED_MESSAGE_TYPES = %i[sent received].freeze

      def append_message(message_type:, text:, sent_at:)
        type = message_type.to_sym

        unless type.in?(ALLOWED_MESSAGE_TYPES)
          raise ArgumentError, 'message_type must be either :sent or :received'
        end

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
