# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::BadgeComponent, type: :component do
  it 'renders badge with default styling' do
    render_inline(described_class.new(text: 'Active'))

    expect(page).to have_css(
      'span.flex.px-3.py-1.text-sm.font-semibold.text-white.bg-gray-500.dark\\:bg-gray-600.rounded-full.w-fit',
      text: 'Active'
    )
  end

  context 'when a type is provided' do
    it 'renders badge with mapped color' do
      render_inline(described_class.new(text: 'Approved', type: :success))

      expect(page).to have_css(
        'span.bg-green-500.dark\\:bg-green-600',
        text: 'Approved'
      )
    end
  end

  context 'when a custom color is provided' do
    it 'renders badge with explicit color' do
      render_inline(described_class.new(text: 'Alert', color: :red))

      expect(page).to have_css(
        'span.bg-red-500.dark\\:bg-red-600',
        text: 'Alert'
      )
    end
  end
end
