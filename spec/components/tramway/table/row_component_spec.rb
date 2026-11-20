# frozen_string_literal: true

require 'rails_helper'

ROW_MEDIUM_ROW_CLASSES = %w[div-table-row grid tramway-data-table__row].freeze
ROW_MEDIUM_CELL_CLASSES = %w[div-table-cell tramway-data-table__cell tramway-data-table__cell--truncate].freeze
ROW_SMALL_ROW_CLASSES = %w[div-table-row grid tramway-data-table__row tramway-data-table__row--sm].freeze
ROW_SMALL_CELL_CLASSES = %w[
  div-table-cell tramway-data-table__cell tramway-data-table__cell--truncate tramway-data-table__cell--sm
].freeze
ROW_LARGE_ROW_CLASSES = %w[div-table-row grid tramway-data-table__row tramway-data-table__row--lg].freeze
ROW_LARGE_CELL_CLASSES = %w[
  div-table-cell tramway-data-table__cell tramway-data-table__cell--truncate tramway-data-table__cell--lg
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

    expect(page).to have_css('.div-table-row.tramway-data-table__row')
  end

  it 'keeps the current medium row and cell classes' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:medium)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: ROW_MEDIUM_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: ROW_MEDIUM_CELL_CLASSES, text: 'Alice')
    expect(page.find('.div-table-row')[:style]).to eq(
      'grid-template-columns: repeat(2, minmax(10rem, 1fr)); min-width: 21.0rem'
    )
  end

  it 'renders the small size variant' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:small)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: ROW_SMALL_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: ROW_SMALL_CELL_CLASSES, text: 'Alice')
    expect(page.find('.div-table-row')[:style]).to eq(
      'grid-template-columns: repeat(2, minmax(8rem, 1fr)); min-width: 16.5rem'
    )
  end

  it 'renders the large size variant' do
    component = described_class.new(cells: [['Name', 'Alice'], ['Email', 'alice@example.com']])
    allow(component).to receive(:tramway_table_size).and_return(:large)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: ROW_LARGE_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: ROW_LARGE_CELL_CLASSES, text: 'Alice')
    expect(page.find('.div-table-row')[:style]).to eq(
      'grid-template-columns: repeat(2, minmax(12rem, 1fr)); min-width: 25.5rem'
    )
  end
end
