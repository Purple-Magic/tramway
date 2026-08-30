# frozen_string_literal: true

require 'rails_helper'

GRID_SHELL_SELECTOR = 'div.relative.overflow-auto.rounded-xl.bg-zinc-950.shadow-inner.dashboard-grid' \
                      '[role="grid"][aria-label="Dashboard grid"][aria-rowcount="8"][aria-colcount="8"]'
GRID_TRACK_SELECTOR = 'div.relative.z-10.grid.gap-1[role="presentation"]'
GRID_WIDTH_STYLE_SELECTOR = 'div[style*="min-width: calc(8 * 20em + 7 * 0.25rem)"]'
GRID_HEIGHT_STYLE_SELECTOR = 'div[style*="min-height: calc(8 * 20em + 7 * 0.25rem)"]'
GRID_COLUMNS_SELECTOR = 'div[aria-hidden="true"] .grid[style*="grid-template-columns: repeat(8, 20em)"]'
GRID_ROWS_SELECTOR = 'div[aria-hidden="true"] .grid[style*="grid-template-rows: repeat(8, 20em)"]'
GRID_CELL_SELECTOR = 'div[aria-hidden="true"] .grid > div[style*="width: 20em; height: 20em;"]'
OUTLINE_HORIZONTAL_SELECTOR = 'div[aria-hidden="true"] > div.absolute.left-0.right-0.h-px.bg-zinc-800'
OUTLINE_VERTICAL_SELECTOR = 'div[aria-hidden="true"] > div.absolute.top-0.bottom-0.w-px.bg-zinc-800'

describe Tramway::GridComponent, type: :component do
  it 'renders a dark dashboard grid with the requested rows and columns' do
    render_inline(described_class.new(rows: 8, columns: 8, options: { class: 'dashboard-grid' }))

    expect(page).to have_css(GRID_SHELL_SELECTOR)
    expect(page).to have_css(GRID_TRACK_SELECTOR)
    expect(page).to have_css(GRID_WIDTH_STYLE_SELECTOR)
    expect(page).to have_css(GRID_HEIGHT_STYLE_SELECTOR)
  end

  it 'renders the grid net for each axis' do
    render_inline(described_class.new(rows: 8, columns: 8, options: { class: 'dashboard-grid' }))

    expect(page).to have_css(GRID_COLUMNS_SELECTOR)
    expect(page).to have_css(GRID_ROWS_SELECTOR)
  end

  it 'renders one cell per slot in the grid' do
    render_inline(described_class.new(rows: 8, columns: 8, options: { class: 'dashboard-grid' })) do
      'Grid content'
    end

    expect(page).to have_css(GRID_CELL_SELECTOR, count: 64, visible: :all)
    expect(page).to have_text 'Grid content'
  end

  it 'renders cell separators when outline is enabled' do
    render_inline(described_class.new(rows: 2, columns: 3, outline: true))

    expect(page).to have_css('div[role="grid"][aria-rowcount="2"][aria-colcount="3"]')
    expect(page).to have_css(OUTLINE_HORIZONTAL_SELECTOR, count: 1, visible: :all)
    expect(page).to have_css(OUTLINE_VERTICAL_SELECTOR, count: 2, visible: :all)
    expect(page).to have_css(GRID_CELL_SELECTOR, count: 6, visible: :all)
  end

  it 'renders the grid net even when empty' do
    render_inline(described_class.new(rows: 3, columns: 4))

    expect(page).to have_css('div[role="grid"][aria-rowcount="3"][aria-colcount="4"]')
    expect(page).not_to have_css(OUTLINE_HORIZONTAL_SELECTOR, visible: :all)
    expect(page).not_to have_css(OUTLINE_VERTICAL_SELECTOR, visible: :all)
  end

  it 'renders the hidden grid cells even when empty' do
    render_inline(described_class.new(rows: 3, columns: 4))

    expect(page).to have_css('div[aria-hidden="true"] .grid > div[style*="width: 20em; height: 20em;"]',
                             count: 12,
                             visible: :all)
    expect(page).to have_css('div[aria-hidden="true"] .grid > div', count: 12, visible: :all)
    expect(page).not_to have_text 'Grid content'
  end
end
