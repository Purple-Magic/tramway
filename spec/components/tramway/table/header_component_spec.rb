# frozen_string_literal: true

require 'rails_helper'

MEDIUM_HEADER_ROW_SELECTOR =
  '.div-table-row.grid.grid-cols-1.gap-4.rounded-t-xl.border-b.border-zinc-800.' \
  'bg-zinc-900.text-zinc-400.md\\:grid-cols-2'
MEDIUM_HEADER_CELL_SELECTOR = '.div-table-cell.hidden.px-6.py-4.first\\:block.md\\:block'
SMALL_HEADER_ROW_SELECTOR =
  '.div-table-row.grid.grid-cols-1.gap-2.rounded-t-xl.border-b.border-zinc-800.' \
  'bg-zinc-900.text-zinc-400.md\\:grid-cols-2'
SMALL_HEADER_CELL_SELECTOR = '.div-table-cell.hidden.px-4.py-2.first\\:block.md\\:block'
LARGE_HEADER_ROW_SELECTOR =
  '.div-table-row.grid.grid-cols-1.gap-6.rounded-t-xl.border-b.border-zinc-800.' \
  'bg-zinc-900.text-zinc-400.md\\:grid-cols-2'
LARGE_HEADER_CELL_SELECTOR = '.div-table-cell.hidden.px-6.py-6.first\\:block.md\\:block'

describe Tramway::Table::HeaderComponent, type: :component do
  it 'uses headers argument to set grid columns' do
    render_inline(described_class.new(headers: %w[Name Email])) do
      '<div class="div-table-cell">Ignored</div>'.html_safe
    end

    expect(page).to have_css('.div-table-row.md\:grid-cols-2', text: 'Name')
    expect(page).to have_css('.div-table-row.md\:grid-cols-2', text: 'Email')
    expect(page).not_to have_text('Ignored')
  end

  it 'counts cells from content when headers are not provided' do
    render_inline(described_class.new) do
      <<~HTML.html_safe
        <div class="div-table-cell">Name</div>
        <div class="div-table-cell hidden">Email</div>
      HTML
    end

    expect(page).to have_css('.div-table-row.md\:grid-cols-2')
    expect(page).to have_css('.div-table-cell.hidden', text: 'Email')
  end

  it 'keeps the current medium header classes' do
    component = described_class.new(headers: %w[Name Email])
    allow(component).to receive(:tramway_table_size).and_return(:medium)

    render_inline(component)

    expect(page).to have_css(MEDIUM_HEADER_ROW_SELECTOR)
    expect(page).to have_css(MEDIUM_HEADER_CELL_SELECTOR, text: 'Name')
  end

  it 'renders the small size variant' do
    component = described_class.new(headers: %w[Name Email])
    allow(component).to receive(:tramway_table_size).and_return(:small)

    render_inline(component)

    expect(page).to have_css(SMALL_HEADER_ROW_SELECTOR)
    expect(page).to have_css(SMALL_HEADER_CELL_SELECTOR, text: 'Name')
  end

  it 'renders the large size variant' do
    component = described_class.new(headers: %w[Name Email])
    allow(component).to receive(:tramway_table_size).and_return(:large)

    render_inline(component)

    expect(page).to have_css(LARGE_HEADER_ROW_SELECTOR)
    expect(page).to have_css(LARGE_HEADER_CELL_SELECTOR, text: 'Name')
  end
end
