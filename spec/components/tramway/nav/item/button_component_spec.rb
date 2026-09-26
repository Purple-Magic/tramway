# frozen_string_literal: true

require 'rails_helper'
describe Tramway::Nav::Item::ButtonComponent, type: :component do
  it 'renders button' do
    render_inline(described_class.new(href: '/test_page')) { 'Sign In' }

    expect(page).to have_css "form[action='/test_page']", text: 'Sign In'
    expect(page).to have_css 'li.whitespace-nowrap'
    expect(page).to have_text 'Sign In'
  end

  it 'renders button with an icon' do
    render_inline(described_class.new(href: '/test_page', icon: 'fa fa-users')) { 'Sign In' }

    expect(page).to have_css 'button i.fa.fa-users[aria-hidden]'
    expect(page).to have_css 'button span.tramway-navbar-item-label', text: 'Sign In'
  end
end
