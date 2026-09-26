# frozen_string_literal: true

require 'rails_helper'

CELL_MEDIUM_SELECTOR = '.div-table-cell.truncate.min-w-0.bg-transparent.px-6.py-4.' \
                       'text-base.font-medium.text-zinc-100'
CELL_SMALL_SELECTOR = '.div-table-cell.truncate.min-w-0.bg-transparent.px-4.py-2.' \
                      'text-sm.font-medium.text-zinc-100'
CELL_LARGE_SELECTOR = '.div-table-cell.truncate.min-w-0.bg-transparent.px-6.py-6.' \
                      'text-lg.font-medium.text-zinc-100'

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

  it 'keeps the cell background transparent' do
    render_inline(described_class.new) do
      'Cell'
    end

    expect(page).to have_css('.div-table-cell.bg-transparent', text: 'Cell')
  end
end
