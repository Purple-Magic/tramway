# frozen_string_literal: true

describe Tailwinds::Nav::Item::ButtonComponent, type: :component do
  it 'renders button' do
    render_inline(described_class.new(href: '/test_page')) { 'Sign In' }

    expect(page).to have_css "form[action='/test_page']", text: 'Sign In'
    expect(page).to have_text 'Sign In'
  end
end
