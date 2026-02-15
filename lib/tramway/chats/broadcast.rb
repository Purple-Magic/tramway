# frozen_string_literal: true

module Tramway
  module Chats
    # This module provides a method to broadcast new chat messages to a Tramway Chat
    module Broadcast
      MESSAGE_TYPES = %i[sent received].freeze

      def tramway_chat_append_message(chat_id:, type:, text:, sent_at:)
        raise ArgumentError, 'message_type must be :sent or :received' unless MESSAGE_TYPES.include?(type.to_sym)

        Turbo::StreamsChannel.broadcast_append_to [chat_id, 'messages'],
                                                  target: 'messages',
                                                  partial: 'tramway/chats/message',
                                                  locals: { type:, text:, sent_at: }
      end
    end
  end
end
