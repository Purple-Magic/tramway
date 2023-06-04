# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::Navbar::ButtonComponent, type: :component do
  it 'renders component' do
    render_inline(described_class.new(text: 'Sign In', href: '/test_page'))

    expect(page).to have_css "form[action='/test_page']", text: 'Sign In'
    expect(page).to have_text 'Sign In'
  end
end
