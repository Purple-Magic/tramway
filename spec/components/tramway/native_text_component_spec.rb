# frozen_string_literal: true

require 'rails_helper'

describe Tramway::NativeTextComponent, type: :component do
  it 'renders markdown headers, bold and italic text' do
    render_inline(described_class.new(text: "# Heading\nThis has **bold** and *italic* text."))

    expect(page).to have_css('h1.text-base', text: 'Heading')
    expect(page).to have_css('p.text-base strong', text: 'bold')
    expect(page).to have_css('p.text-base em', text: 'italic')
  end

  it 'renders unordered lists from markdown list items' do
    render_inline(described_class.new(text: "- First\n- Second"))

    expect(page).to have_css('ul.list-disc.pl-5')
    expect(page).to have_css('ul li.text-base', text: 'First')
    expect(page).to have_css('ul li.text-base', text: 'Second')
  end

  it 'renders markdown and auto-links urls together' do
    render_inline(described_class.new(text: 'Visit **https://example.com/very/long/path/with/query?foo=bar** now'))

    expect(page).to have_css('strong a', text: 'https://example.com/very/long/path/with/q...')
    expect(page).to have_link(
      'https://example.com/very/long/path/with/q...',
      href: 'https://example.com/very/long/path/with/query?foo=bar'
    )
  end
end
