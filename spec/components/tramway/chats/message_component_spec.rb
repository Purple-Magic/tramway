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
                           rounded-lg
                           border
                           border-zinc-800
                           bg-zinc-950
                           text-zinc-200
                           px-4
                           py-3
                           text-sm
                           shadow-sm
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
                           rounded-lg
                           bg-zinc-50
                           px-4
                           py-3
                           text-sm
                           text-zinc-950
                           shadow-sm
                         ])}",
      text: 'Hi there'
    )
  end

  it 'renders links as shortened clickable anchors in message text' do
    message_text = 'Read more at https://example.com/very/long/path/with/query?foo=bar and reply'

    render_inline(described_class.new(type: :sent, text: message_text))

    expect(page).to have_link(
      'https://example.com/very/long/path/with/q...',
      href: 'https://example.com/very/long/path/with/query?foo=bar'
    )

    expect(page).to have_css('a.text-blue-400.hover\\:underline')
  end
  # rubocop:enable RSpec/ExampleLength
end
