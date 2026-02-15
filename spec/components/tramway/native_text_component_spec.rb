# frozen_string_literal: true

require 'rails_helper'

describe Tramway::NativeTextComponent, type: :component do
  it 'renders markdown headers as tailwind styled heading tags' do
    render_inline(described_class.new(text: "# Heading 1\n## Heading 2\n### Heading 3"))

    expect(page).to have_css('h1.text-4xl.font-bold', text: 'Heading 1')
    expect(page).to have_css('h2.text-3xl.font-bold', text: 'Heading 2')
    expect(page).to have_css('h3.text-2xl.font-semibold', text: 'Heading 3')
  end

  it 'renders bold and italic markdown in paragraph text' do
    render_inline(described_class.new(text: 'This has **bold** and *italic* and _also italic_ text.'))

    expect(page).to have_css('p strong', text: 'bold')
    expect(page).to have_css('p em', text: 'italic')
    expect(page).to have_css('p em', text: 'also italic')
  end

  it 'renders markdown unordered lists' do
    render_inline(described_class.new(text: "- First\n- Second"))

    expect(page).to have_css('ul.list-none.pl-5')
    expect(page).to have_css('ul li.text-base.marker\\:hidden', text: 'First')
    expect(page).to have_css('ul li.text-base.marker\\:hidden', text: 'Second')
  end

  it 'renders markdown and auto-links urls together' do
    render_inline(described_class.new(text: 'Visit **https://example.com/very/long/path/with/query?foo=bar** now'))

    expect(page).to have_css('strong a', text: 'https://example.com/very/long/path/with/q...')
    expect(page).to have_link(
      'https://example.com/very/long/path/with/q...',
      href: 'https://example.com/very/long/path/with/query?foo=bar'
    )
  end

  it 'escapes html while still applying markdown emphasis' do
    render_inline(described_class.new(text: '**<script>alert(1)</script>**'))

    expect(page).to have_css('strong', text: '<script>alert(1)</script>')
    expect(page).to have_no_css('script')
  end
end
