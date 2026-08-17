# frozen_string_literal: true

require 'rails_helper'

describe Tramway::NavbarComponent, type: :component do
  context 'with title checks' do
    it 'renders title' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_text 'Purple Magic'
    end
  end

  context 'with mobile controls' do
    it 'renders a bottom close button for mobile menu' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_button 'Close'
      expect(page).not_to have_css '#mobile-menu-close-button', text: '⨯'
    end
  end

  context 'with desktop direction controls' do
    it 'defaults to the expanded vertical desktop layout' do
      render_inline(described_class.new(title: 'Purple Magic', left_items: ["<a href='/test'>Test</a>".html_safe]))

      desktop_navbar_css = [
        '#desktop-navbar.md\\:fixed.md\\:left-0.md\\:top-0.md\\:z-40.md\\:w-72',
        '[data-expanded="true"]'
      ].join

      expect(page).to have_css desktop_navbar_css
      expect(page).to have_css '#desktop-navbar-header'
      expect(page).to have_css '#desktop-navbar-content'
      expect(page).to have_css '#desktop-navbar-toggle-button[aria-label="Collapse sidebar"]'
      expect(page).to have_css '.tramway-navbar-desktop-vertical'
    end

    it 'adds extra top spacing before the vertical items list' do
      render_inline(described_class.new(title: 'Purple Magic', left_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css '#desktop-navbar-content ul.tramway-navbar-desktop-vertical-list.mt-8'
    end

    it 'uses a left chevron icon when expanded' do
      render_inline(described_class.new(title: 'Purple Magic', left_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css '#desktop-navbar-toggle-icon.fa.fa-chevron-left'
    end

    it 'renders the current desktop layout when horizontal is requested' do
      render_inline(
        described_class.new(
          title: 'Purple Magic',
          direction: :horizontal,
          left_items: ["<a href='/test'>Test</a>".html_safe]
        )
      )

      expect(page).not_to have_css '#desktop-navbar-content'
      expect(page).not_to have_css '#desktop-navbar-toggle-button'
      expect(page).to have_css 'nav ul.flex-row.items-center.space-x-4.ml-4.hidden.md\\:flex'
    end
  end

  context 'with mobile nav items' do
    it 'uses larger touch targets for nav items' do
      render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css('#mobile-menu a[href="/test"]', text: 'Test')
    end
  end

  context 'with items checks' do
    it 'renders left items' do
      render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css 'nav'
    end

    it 'renders right items' do
      render_inline(described_class.new(right_items: ["<a href='/test'>Test</a>".html_safe]))

      expect(page).to have_css 'nav'
    end

    it 'renders left and right items' do
      links = ["<a href='/test'>Test</a>".html_safe]

      render_inline(described_class.new(right_items: links, left_items: links))

      expect(page).to have_css 'nav'
    end
  end
end
