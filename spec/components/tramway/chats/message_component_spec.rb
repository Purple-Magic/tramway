# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Chats::MessageComponent, type: :component do
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

    expect(page).to have_css('.tramway-chat__bubble.tramway-chat__bubble--received', text: 'Hello')
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

    expect(page).to have_css('.tramway-chat__bubble.tramway-chat__bubble--sent', text: 'Hi there')
  end

  it 'renders links as shortened clickable anchors in message text' do
    message_text = 'Read more at https://example.com/very/long/path/with/query?foo=bar and reply'

    render_inline(described_class.new(type: :sent, text: message_text))

    expect(page).to have_link(
      'https://example.com/very/long/path/with/q...',
      href: 'https://example.com/very/long/path/with/query?foo=bar'
    )

    expect(page).to have_css('a.tramway-link')
  end
end
