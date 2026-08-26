# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Grid::CardComponent, type: :component do
  it 'renders a dashboard-style card with the requested span' do
    render_inline(described_class.new(size: [1, 2], options: { class: 'card-highlight' })) do
      'Card content'
    end

    expect(page).to have_css(
      'article.h-full.w-full.overflow-hidden.rounded-2xl.border.border-zinc-800.bg-zinc-900\\/80.p-4.shadow-sm.backdrop-blur.card-highlight[role="gridcell"][aria-label="Dashboard card"][aria-rowspan="1"][aria-colspan="2"][style*="grid-column: span 2"][style*="grid-row: span 1"]'
    )
    expect(page).to have_text 'Card content'
  end

  it 'fills exactly one grid cell when size is 1 by 1' do
    render_inline(described_class.new(size: [1, 1])) do
      'Single cell'
    end

    expect(page).to have_css('article.overflow-hidden[aria-rowspan="1"][aria-colspan="1"][style*="grid-column: span 1"][style*="grid-row: span 1"]')
    expect(page).to have_text 'Single cell'
  end
end
