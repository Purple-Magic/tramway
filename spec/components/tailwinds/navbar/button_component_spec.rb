# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::Navbar::ButtonComponent, type: :component do
  it 'renders with button_to' do
    render_inline(described_class.new(action: '/test_page')) { 'Sign In' }

    expect(page).to have_css "form[action='/test_page']", text: 'Sign In'
    expect(page).to have_text 'Sign In'
  end

  it 'renders with link_to' do
    render_inline(described_class.new(href: '/test_page')) { 'Sign In' }

    expect(page).to have_css "a[href='/test_page']", text: 'Sign In'
    expect(page).to have_text 'Sign In'
  end
end
