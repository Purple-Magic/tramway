# frozen_string_literal: true

require 'rails_helper'

describe Tramway::GridComponent, type: :component do
  it 'renders a dark dashboard grid with the requested rows and columns' do
    card_html = render_inline(Tramway::Grid::CardComponent.new(size: [1, 1])) do
      'Grid content'
    end.to_html

    render_inline(described_class.new(rows: 8, columns: 8, options: { class: 'dashboard-grid' })) do
      card_html.html_safe
    end

    expect(page).to have_css(
      'div.relative.overflow-auto.rounded-xl.bg-zinc-950.shadow-inner.dashboard-grid[role="grid"][aria-label="Dashboard grid"][aria-rowcount="8"][aria-colcount="8"]'
    )
    expect(page).to have_css('div.relative.z-10.grid.gap-1[role="presentation"]')
    expect(page).to have_css('div[style*="min-width: calc(8 * 20em)"]')
    expect(page).to have_css('div[style*="min-height: calc(8 * 20em)"]')
    expect(page).to have_css('div[aria-hidden="true"] .grid[style*="grid-template-columns: repeat(8, 20em)"]')
    expect(page).to have_css('div[aria-hidden="true"] .grid[style*="grid-template-rows: repeat(8, 20em)"]')
    expect(page).to have_css('div[aria-hidden="true"] .grid > div[style*="width: 20em; height: 20em;"]', count: 64, visible: :all)
    expect(page).to have_css('div[aria-hidden="true"] .grid > div', count: 64, visible: :all)
    expect(page).to have_css('article[role="gridcell"][aria-rowspan="1"][aria-colspan="1"][style*="grid-column: span 1"]')
    expect(page).to have_text 'Grid content'
  end

  it 'renders cell borders when outline is enabled' do
    render_inline(described_class.new(rows: 2, columns: 3, outline: true))

    expect(page).to have_css('div[role="grid"][aria-rowcount="2"][aria-colcount="3"]')
    expect(page).to have_css('div[aria-hidden="true"] .grid > div.border.border-zinc-800', count: 6, visible: :all)
    expect(page).to have_css('div[aria-hidden="true"] .grid > div[style*="width: 20em; height: 20em;"]', count: 6, visible: :all)
  end

  it 'renders the grid net even when empty' do
    render_inline(described_class.new(rows: 3, columns: 4))

    expect(page).to have_css('div[role="grid"][aria-rowcount="3"][aria-colcount="4"]')
    expect(page).not_to have_css('div[aria-hidden="true"] .grid > div.border.border-zinc-800', visible: :all)
    expect(page).to have_css('div[aria-hidden="true"] .grid > div[style*="width: 20em; height: 20em;"]', count: 12, visible: :all)
    expect(page).to have_css('div[aria-hidden="true"] .grid > div', count: 12, visible: :all)
    expect(page).not_to have_text 'Grid content'
  end
end
