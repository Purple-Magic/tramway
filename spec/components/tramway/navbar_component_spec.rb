# frozen_string_literal: true

require 'rails_helper'

describe Tramway::NavbarComponent, type: :component do
  context 'with title checks' do
    it 'renders title' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_text 'Purple Magic'
    end
  end

  context 'with items checks' do
    it 'renders left items' do
      render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>"]))

      expect(page).to have_css 'nav'
    end

    it 'renders right items' do
      render_inline(described_class.new(right_items: ["<a href='/test'>Test</a>"]))

      expect(page).to have_css 'nav'
    end

    it 'renders left and right items' do
      links = ["<a href='/test'>Test</a>"]

      render_inline(described_class.new(right_items: links, left_items: links))

      expect(page).to have_css 'nav'
    end
  end
end
