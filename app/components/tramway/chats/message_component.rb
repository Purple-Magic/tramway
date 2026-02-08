# frozen_string_literal: true

module Chats
  class MessageComponent < Tramway::BaseComponent
    option :message
    option :size, optional: true, default: -> { :middle }

    def data_view
      if message.data.nil?
        nil
      elsif array2D?(message.data)
        :table
      end
    end

    def text_color
      if pending?
        'text-gray-400 dark:text-gray-600'
      else
        'text-black dark:text-white'
      end
    end

    private

    def array2D?(array)
      array.is_a?(Array) && array.all? do |inner|
        inner.is_a?(Array) && inner.none? { |e| e.is_a?(Array) }
      end
    end

    def on_the_left?
      message.message_type.in? %w[lead_message bot_message]
    end

    def on_the_right?
      message.message_type.in? %w[sender_message user_message]
    end

    def text
      if message.respond_to?(:text) && message.text.present?
        message.text
      else
        message.content
      end
    end

    def show_sent_at?
      message.respond_to?(:sent_at) && message.sent_at.present?
    end

    def pending?
      message.respond_to?(:pending?) && message.pending?
    end

    def failed?
      message.respond_to?(:failed?) && message.failed?
    end
  end
end
