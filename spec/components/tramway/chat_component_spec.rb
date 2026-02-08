# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ChatComponent, type: :component do
  DummyMessage = Struct.new(:message_type, :text, :data, :sent_at, :pending, :failed, keyword_init: true) do
    def pending? = pending
    def failed? = failed
    def content = text
  end

  DummyChat = Struct.new(:id, :messages, :disabled, keyword_init: true) do
    def disabled? = disabled
  end

  it 'renders common chat container styles' do
    message = DummyMessage.new(message_type: 'lead_message', text: 'Hello')
    chat = DummyChat.new(id: 123, messages: [message])

    render_inline(described_class.new(chat:))

    expect(page).to have_css(
      "#chat.#{class_selector(%w[mx-auto flex flex-col mt-6 max-h-full w-full rounded-2xl border border-gray-200 bg-white shadow-sm dark:border-gray-700 dark:bg-gray-900 h-[650px]])}"
    )
    expect(page).to have_css(
      "#messages.#{class_selector(%w[flex-1 overflow-y-auto bg-gray-50 p-6 space-y-4 dark:bg-gray-800/60 text-gray-900 dark:text-gray-100])}"
    )
  end
end
