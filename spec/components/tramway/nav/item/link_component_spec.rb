# frozen_string_literal: true

require 'rails_helper'
describe Tramway::Nav::Item::LinkComponent, type: :component do
  it 'renders link' do
    render_inline(described_class.new(href: '/test_page')) { 'Sign In' }

    expect(page).to have_css "a[href='/test_page']", text: 'Sign In'
    expect(page).to have_css 'li.whitespace-nowrap'
    expect(page).to have_text 'Sign In'
  end

  it 'renders link with turbo options' do
    render_inline(described_class.new(href: '/test_page', method: :delete, confirm: 'Yes?')) { 'Sign In' }

    expect(page).to have_css "a[data-turbo-method='delete'][data-turbo-confirm='Yes?']"
  end

  it 'renders link with an icon' do
    render_inline(described_class.new(href: '/test_page', icon: 'fa fa-users')) { 'Sign In' }

    expect(page).to have_css 'a i.fa.fa-users[aria-hidden]'
    expect(page).to have_css 'a span.tramway-navbar-item-label', text: 'Sign In'
  end

  it 'does not render an icon when it is not provided' do
    render_inline(described_class.new(href: '/test_page')) { 'Sign In' }

    expect(page).not_to have_css 'a i'
  end
end
