# frozen_string_literal: true

require 'rails_helper'

ROW_MEDIUM_ROW_CLASSES = %w[
  div-table-row grid gap-4 border-b border-zinc-800 bg-transparent last:border-b-0
].freeze
ROW_MEDIUM_CELL_CLASSES = %w[
  div-table-cell truncate min-w-0 bg-transparent px-6 py-4 text-xs font-medium text-zinc-100 sm:text-base
].freeze
ROW_SMALL_ROW_CLASSES = %w[
  div-table-row grid gap-2 border-b border-zinc-800 bg-transparent last:border-b-0
].freeze
ROW_SMALL_CELL_CLASSES = %w[
  div-table-cell truncate min-w-0 bg-transparent px-4 py-2 text-sm font-medium text-zinc-100 sm:text-sm
].freeze
ROW_LARGE_ROW_CLASSES = %w[
  div-table-row grid gap-6 border-b border-zinc-800 bg-transparent last:border-b-0
].freeze
ROW_LARGE_CELL_CLASSES = %w[
  div-table-cell truncate min-w-0 bg-transparent px-6 py-6 text-lg font-medium text-zinc-100
].freeze

describe Tramway::Table::RowComponent, type: :component do
  let(:row_content) do
    <<~HTML.html_safe
      <div class="div-table-cell">Name</div>
      <div class="div-table-cell hidden">Email</div>
    HTML
  end

  it 'renders every cell from content without a preview drawer' do
    render_inline(described_class.new) { row_content }

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

    expect(page).to have_css('.div-table-row', class: ROW_MEDIUM_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: ROW_MEDIUM_CELL_CLASSES, text: 'Alice')
    expect(page.find('.div-table-row')[:style]).to eq 'grid-template-columns: repeat(2, minmax(10rem, 1fr))'
  end

  it 'renders the small size variant' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:small)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: ROW_SMALL_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: ROW_SMALL_CELL_CLASSES, text: 'Alice')
    expect(page.find('.div-table-row')[:style]).to eq 'grid-template-columns: repeat(2, minmax(8rem, 1fr))'
  end

  it 'renders the large size variant' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:large)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: ROW_LARGE_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: ROW_LARGE_CELL_CLASSES, text: 'Alice')
    expect(page.find('.div-table-row')[:style]).to eq 'grid-template-columns: repeat(2, minmax(12rem, 1fr))'
  end
end
