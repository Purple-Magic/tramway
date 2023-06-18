# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::NavbarComponent, type: :component do
  it 'renders brand' do
    render_inline(described_class.new(brand: 'Purple Magic'))

    expect(page).to have_text 'Purple Magic'
  end

  it 'renders left items' do
    render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>"]))

    expect(page).to have_css 'nav .flex ul.flex.items-center.space-x-4'
  end

  it 'renders right items' do
    render_inline(described_class.new(right_items: ["<a href='/test'>Test</a>"]))

    expect(page).to have_css 'nav ul.flex.items-center.space-x-4'
  end

  it 'renders left and right items' do
    links = ["<a href='/test'>Test</a>"]

    render_inline(described_class.new(right_items: links, left_items: links))

    expect(page).to have_css 'nav .flex ul.flex.items-center.space-x-4'
    expect(page).to have_css 'nav ul.flex.items-center.space-x-4'
  end
end
