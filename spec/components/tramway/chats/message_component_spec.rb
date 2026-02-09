# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Chats::MessageComponent, type: :component do
  # rubocop:disable RSpec/ExampleLength
  it 'renders common styling for left aligned messages' do
    message_text = 'Hello'

    render_inline(described_class.new(type: :received, text: message_text))

    expect(page).to have_css(
      ".#{class_selector(%w[
                           flex
                           flex-col
                           gap-1
                           items-start
                         ])}"
    )

    expect(page).to have_css(
      ".#{class_selector(%w[
                           max-w-lg
                           rounded-2xl
                           rounded-tl-md
                           bg-gray-800
                           px-4
                           py-3
                           text-sm
                           shadow-sm
                           ring-1
                           text-white
                           ring-gray-700
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
                           flex-col
                           items-end
                           gap-1
                         ])}"
    )

    expect(page).to have_css(
      ".#{class_selector(%w[
                           max-w-lg
                           rounded-2xl
                           rounded-tr-md
                           bg-blue-600
                           px-4
                           py-3
                           text-sm
                           text-white
                           shadow-sm
                           ring-1
                           ring-gray-700
                         ])}",
      text: 'Hi there'
    )
  end
  # rubocop:enable RSpec/ExampleLength
end
