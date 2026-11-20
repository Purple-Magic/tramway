# frozen_string_literal: true

require 'rails_helper'

MEDIUM_HEADER_ROW_CLASSES = %w[div-table-row grid tramway-data-table__head].freeze
MEDIUM_HEADER_CELL_CLASSES = %w[div-table-cell tramway-data-table__head-cell].freeze
SMALL_HEADER_ROW_CLASSES = %w[div-table-row grid tramway-data-table__head tramway-data-table__head--sm].freeze
SMALL_HEADER_CELL_CLASSES = %w[div-table-cell tramway-data-table__head-cell].freeze
LARGE_HEADER_ROW_CLASSES = %w[div-table-row grid tramway-data-table__head tramway-data-table__head--lg].freeze
LARGE_HEADER_CELL_CLASSES = %w[div-table-cell tramway-data-table__head-cell].freeze

describe Tramway::Table::HeaderComponent, type: :component do
  it 'uses headers argument to set grid columns' do
    render_inline(described_class.new(headers: %w[Name Email])) do
      '<div class="div-table-cell">Ignored</div>'.html_safe
    end

    expect(page.find('.div-table-row')[:style]).to eq(
      'grid-template-columns: repeat(2, minmax(10rem, 1fr)); min-width: 21.0rem'
    )
    expect(page).to have_css('.div-table-row', text: 'Name')
    expect(page).to have_css('.div-table-row', text: 'Email')
    expect(page).not_to have_text('Ignored')
  end

  it 'counts cells from content when headers are not provided' do
    render_inline(described_class.new) do
      <<~HTML.html_safe
        <div class="div-table-cell">Name</div>
        <div class="div-table-cell hidden">Email</div>
      HTML
    end

    expect(page.find('.div-table-row')[:style]).to eq(
      'grid-template-columns: repeat(2, minmax(10rem, 1fr)); min-width: 21.0rem'
    )
    expect(page).to have_css('.div-table-cell.hidden', text: 'Email')
  end

  it 'keeps the current medium header classes' do
    component = described_class.new(headers: %w[Name Email])
    allow(component).to receive(:tramway_table_size).and_return(:medium)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: MEDIUM_HEADER_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: MEDIUM_HEADER_CELL_CLASSES, text: 'Name')
  end

  it 'renders the small size variant' do
    component = described_class.new(headers: %w[Name Email])
    allow(component).to receive(:tramway_table_size).and_return(:small)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: SMALL_HEADER_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: SMALL_HEADER_CELL_CLASSES, text: 'Name')
  end

  it 'renders the large size variant' do
    component = described_class.new(headers: %w[Name Email])
    allow(component).to receive(:tramway_table_size).and_return(:large)

    render_inline(component)

    expect(page).to have_css('.div-table-row', class: LARGE_HEADER_ROW_CLASSES)
    expect(page).to have_css('.div-table-cell', class: LARGE_HEADER_CELL_CLASSES, text: 'Name')
  end
end
