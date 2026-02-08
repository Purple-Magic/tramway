# frozen_string_literal: true

module Tramway
  class ChatComponent < Tramway::BaseComponent
    option :chat
    option :message_form, optional: true, default: -> {}
    option :options, optional: true, default: -> { {} }
    option :namespace, optional: true, default: -> {}
    option :size, optional: true, default: -> { :medium }
    option :send_message_path
    option :send_messages_enabled, optional: true, default: -> { true }

    def disabled?
      chat.respond_to?(:disabled?) && chat.disabled?
    end
  end
end
