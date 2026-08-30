# frozen_string_literal: true

require 'rails_helper'

ROW_MEDIUM_ROW_SELECTOR =
  '.div-table-row.grid.grid-cols-1.gap-4.border-b.' \
  'border-zinc-800.bg-transparent.last\\:border-b-0.' \
  'md\\:grid-cols-2'
ROW_MEDIUM_CELL_SELECTOR = '.div-table-cell.bg-transparent.px-6.py-4.text-xs.font-medium.text-zinc-100.sm\\:text-base'
ROW_SMALL_ROW_SELECTOR =
  '.div-table-row.grid.grid-cols-1.gap-2.border-b.' \
  'border-zinc-800.bg-transparent.last\\:border-b-0.' \
  'md\\:grid-cols-2'
ROW_SMALL_CELL_SELECTOR = '.div-table-cell.bg-transparent.px-4.py-2.text-sm.font-medium.text-zinc-100.sm\\:text-sm'
ROW_LARGE_ROW_SELECTOR =
  '.div-table-row.grid.grid-cols-1.gap-6.border-b.' \
  'border-zinc-800.bg-transparent.last\\:border-b-0.' \
  'md\\:grid-cols-2'
ROW_LARGE_CELL_SELECTOR = '.div-table-cell.bg-transparent.px-6.py-6.text-lg.font-medium.text-zinc-100'

describe Tramway::Table::RowComponent, type: :component do
  let(:row_content) do
    <<~HTML.html_safe
      <div class="div-table-cell">Name</div>
      <div class="div-table-cell hidden">Email</div>
    HTML
  end

  it 'does not render preview panel when preview is false' do
    render_inline(described_class.new(preview: false)) { row_content }

    expect(page).to have_css('.div-table-row', text: 'Name')
    expect(page).to have_css('.div-table-row', text: 'Email')
    expect(page).not_to have_css('#roll-up')
  end

  it 'keeps row backgrounds transparent when rendering cells' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:medium)

    render_inline(component)

    expect(page).to have_css('.div-table-row.bg-transparent')
  end

  it 'keeps the current medium row and cell classes' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:medium)

    render_inline(component)

    expect(page).to have_css(ROW_MEDIUM_ROW_SELECTOR)
    expect(page).to have_css(ROW_MEDIUM_CELL_SELECTOR, text: 'Alice')
  end

  it 'renders the small size variant' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:small)

    render_inline(component)

    expect(page).to have_css(ROW_SMALL_ROW_SELECTOR)
    expect(page).to have_css(ROW_SMALL_CELL_SELECTOR, text: 'Alice')
  end

  it 'renders the large size variant' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:large)

    render_inline(component)

    expect(page).to have_css(ROW_LARGE_ROW_SELECTOR)
    expect(page).to have_css(ROW_LARGE_CELL_SELECTOR, text: 'Alice')
  end
end
