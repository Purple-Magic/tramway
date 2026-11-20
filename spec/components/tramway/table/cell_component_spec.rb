# frozen_string_literal: true

require 'rails_helper'

CELL_MEDIUM_SELECTOR = '.div-table-cell.tramway-data-table__cell.tramway-data-table__cell--truncate'
CELL_SMALL_SELECTOR = '.div-table-cell.tramway-data-table__cell--sm.tramway-data-table__cell--truncate'
CELL_LARGE_SELECTOR = '.div-table-cell.tramway-data-table__cell--lg.tramway-data-table__cell--truncate'

describe Tramway::Table::CellComponent, type: :component do
  it 'keeps the current medium cell classes' do
    component = described_class.new
    allow(component).to receive(:tramway_table_size).and_return(:medium)

    render_inline(component) do
      'Cell'
    end

    expect(page).to have_css(CELL_MEDIUM_SELECTOR, text: 'Cell')
  end

  it 'renders the small size variant' do
    component = described_class.new
    allow(component).to receive(:tramway_table_size).and_return(:small)

    render_inline(component) do
      'Cell'
    end

    expect(page).to have_css(CELL_SMALL_SELECTOR, text: 'Cell')
  end

  it 'renders the large size variant' do
    component = described_class.new
    allow(component).to receive(:tramway_table_size).and_return(:large)

    render_inline(component) do
      'Cell'
    end

    expect(page).to have_css(CELL_LARGE_SELECTOR, text: 'Cell')
  end

  it 'renders the shared data table cell primitive' do
    render_inline(described_class.new) do
      'Cell'
    end

    expect(page).to have_css('.div-table-cell.tramway-data-table__cell', text: 'Cell')
  end

  it 'truncates content by default' do
    render_inline(described_class.new) do
      'Cell'
    end

    expect(page).to have_css('.div-table-cell.tramway-data-table__cell--truncate', text: 'Cell')
  end

  it 'does not truncate content when truncate: false is passed' do
    render_inline(described_class.new(truncate: false)) do
      'Cell'
    end

    expect(page).to have_css('.div-table-cell', text: 'Cell')
    expect(page).to have_no_css('.div-table-cell.tramway-data-table__cell--truncate')
  end
end
