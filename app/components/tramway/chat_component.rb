# frozen_string_literal: true

module Tramway
  class ChatComponent < Tramway::BaseComponent
    option :chat_id
    option :messages
    option :message_form, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }
    option :send_message_path
    option :send_messages_enabled, optional: true, default: -> { true }

    def disabled?
      options[:disabled]
    end
  end
end
