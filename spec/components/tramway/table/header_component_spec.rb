# frozen_string_literal: true

require 'rails_helper'

MEDIUM_HEADER_ROW_CLASSES = %w[
  div-table-row grid gap-4 rounded-t-xl border-b border-zinc-800
  bg-zinc-900 text-zinc-400 grid-cols-[repeat(2,minmax(10rem,1fr))]
].freeze
MEDIUM_HEADER_CELL_CLASSES = %w[div-table-cell border-b border-zinc-800 truncate min-w-0 px-6 py-4].freeze
SMALL_HEADER_ROW_CLASSES = %w[
  div-table-row grid gap-2 rounded-t-xl border-b border-zinc-800
  bg-zinc-900 text-zinc-400 grid-cols-[repeat(2,minmax(8rem,1fr))]
].freeze
SMALL_HEADER_CELL_CLASSES = %w[div-table-cell border-b border-zinc-800 truncate min-w-0 px-4 py-2].freeze
LARGE_HEADER_ROW_CLASSES = %w[
  div-table-row grid gap-6 rounded-t-xl border-b border-zinc-800
  bg-zinc-900 text-zinc-400 grid-cols-[repeat(2,minmax(12rem,1fr))]
].freeze
LARGE_HEADER_CELL_CLASSES = %w[div-table-cell border-b border-zinc-800 truncate min-w-0 px-6 py-6].freeze

describe Tramway::Table::HeaderComponent, type: :component do
  it 'uses headers argument to set grid columns' do
    render_inline(described_class.new(headers: %w[Name Email])) do
      '<div class="div-table-cell">Ignored</div>'.html_safe
    end

    expect(page).to have_css('.div-table-row', class: 'grid-cols-[repeat(2,minmax(10rem,1fr))]', text: 'Name')
    expect(page).to have_css('.div-table-row', class: 'grid-cols-[repeat(2,minmax(10rem,1fr))]', text: 'Email')
    expect(page).not_to have_text('Ignored')
  end

  it 'counts cells from content when headers are not provided' do
    render_inline(described_class.new) do
      <<~HTML.html_safe
        <div class="div-table-cell">Name</div>
        <div class="div-table-cell hidden">Email</div>
      HTML
    end

    expect(page).to have_css('.div-table-row', class: 'grid-cols-[repeat(2,minmax(10rem,1fr))]')
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
