# frozen_string_literal: true

require 'rails_helper'

describe Tramway::NavbarComponent, type: :component do
  context 'with title checks' do
    it 'renders title' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_text 'Purple Magic'
    end
  end

  context 'with direction checks' do
    it 'uses the default vertical desktop layout' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_css 'nav[class*="md:left-0"][class*="md:flex-col"][class*="md:w-64"]', visible: :all
      expect(page).to have_css 'style', visible: :all, text: 'padding-left: 16rem;'
      expect(page).to have_css 'style', visible: :all, text: "body[data-tramway-navbar-collapsed='true']"
      expect(page).to have_css '#desktop-navbar-collapse-button', visible: :all
      expect(page).to have_css '#desktop-navbar-collapse-button svg[data-tramway-navbar-collapse-icon]', visible: :all
    end

    it 'renders the horizontal desktop layout when requested' do
      render_inline(described_class.new(title: 'Purple Magic', direction: :horizontal))

      expect(page).to have_css 'nav .md\\:justify-between', visible: :all
      expect(page).not_to have_css 'nav[class*="md:left-0"]', visible: :all
      expect(page).not_to have_css 'style', visible: :all, text: 'padding-left: 16rem;'
    end
  end

  context 'with mobile controls' do
    it 'renders a bottom close button for mobile menu' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_button 'Close'
      expect(page).not_to have_css '#mobile-menu-close-button', text: '⨯'
    end
  end

  context 'with mobile nav items' do
    it 'uses larger touch targets for nav items' do
      render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css('#mobile-menu a[href="/test"]', visible: :all, text: 'Test')
    end
  end

  context 'with items checks' do
    it 'renders left items' do
      render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css 'nav', visible: :all
    end

    it 'renders right items' do
      render_inline(described_class.new(right_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css 'nav', visible: :all
    end

    it 'renders left and right items' do
      links = ["<a href='/test'>Test</a>".html_safe]

      render_inline(described_class.new(right_items: links, left_items: links))

      expect(page).to have_css 'nav', visible: :all
    end
  end
end
