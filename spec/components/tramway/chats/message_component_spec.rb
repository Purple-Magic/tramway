# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Chats::MessageComponent, type: :component do
  it 'renders common styling for left aligned messages' do
    message_text = 'Hello'

    render_inline(described_class.new(type: :received, text: message_text))

    expect(page).to have_css(
      ".#{class_selector(%w[
        max-w-lg
        rounded-2xl
        rounded-tl-md
        bg-white
        px-4
        py-3
        text-sm
        text-gray-900
        shadow-sm
        ring-1
        ring-gray-200
        dark:bg-gray-800
        dark:text-gray-100
        dark:ring-gray-700
      ])}",
      text: 'Hello'
    )
  end

  it 'renders common styling for right aligned messages' do
    message_text = 'Hi there'

    render_inline(described_class.new(type: :sent, text: message_text))

    expect(page).to have_css(
      ".#{class_selector(%w[
        flex
        max-w-lg
        items-end
        gap-2
        rounded-2xl
        rounded-tr-md
        bg-blue-600
        px-4
        py-3
        text-sm
        text-white
        shadow-sm
        dark:bg-blue-500
      ])}",
      text: 'Hi there'
    )
  end
end
