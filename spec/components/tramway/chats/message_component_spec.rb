# frozen_string_literal: true

require 'rails_helper'

describe Chats::MessageComponent, type: :component do
  DummyMessage = Struct.new(:message_type, :text, :data, :sent_at, :pending, :failed, keyword_init: true) do
    def pending? = pending
    def failed? = failed
    def content = text
  end

  it 'renders common styling for left aligned messages' do
    message = DummyMessage.new(message_type: 'lead_message', text: 'Hello')

    render_inline(described_class.new(message:))

    expect(page).to have_css(
      ".#{class_selector(%w[max-w-lg rounded-2xl rounded-tl-md bg-white px-4 py-3 text-sm text-gray-900 shadow-sm ring-1 ring-gray-200 dark:bg-gray-800 dark:text-gray-100 dark:ring-gray-700])}",
      text: 'Hello'
    )
  end

  it 'renders common styling for right aligned messages' do
    message = DummyMessage.new(message_type: 'sender_message', text: 'Hi there')

    render_inline(described_class.new(message:))

    expect(page).to have_css(
      ".#{class_selector(%w[flex max-w-lg items-end gap-2 rounded-2xl rounded-tr-md bg-blue-600 px-4 py-3 text-sm text-white shadow-sm dark:bg-blue-500])}",
      text: 'Hi there'
    )
  end
end
