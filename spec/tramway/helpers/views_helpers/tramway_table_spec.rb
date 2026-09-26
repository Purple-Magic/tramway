# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

TABLE_HELPER_SMALL_HEADER_ROW_CLASSES =
  'div-table-row grid gap-2 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400'
TABLE_HELPER_SMALL_HEADER_ROW_STYLE =
  'grid-template-columns: repeat(2, minmax(8rem, 1fr)); min-width: 16.5rem'
TABLE_HELPER_SMALL_HEADER_CELL_CLASSES = 'div-table-cell border-b border-zinc-800 truncate min-w-0 px-4 py-2'
TABLE_HELPER_SMALL_CELL_CLASSES = 'div-table-cell truncate min-w-0 bg-transparent px-4 py-2 text-sm font-medium ' \
                                  'text-zinc-100'
TABLE_HELPER_MEDIUM_HEADER_ROW_CLASSES =
  'div-table-row grid gap-4 rounded-t-xl border-b border-zinc-800 bg-zinc-900 text-zinc-400'
TABLE_HELPER_MEDIUM_HEADER_ROW_STYLE =
  'grid-template-columns: repeat(2, minmax(10rem, 1fr)); min-width: 21.0rem'
TABLE_HELPER_MEDIUM_HEADER_CELL_CLASSES = 'div-table-cell border-b border-zinc-800 truncate min-w-0 px-6 py-4'
TABLE_HELPER_MEDIUM_CELL_CLASSES = 'div-table-cell truncate min-w-0 bg-transparent px-6 py-4 text-base font-medium ' \
                                   'text-zinc-100'

RENDER_TABLE_FRAGMENT = lambda do |view, size: :medium|
  view.tramway_table(size:) do
    view.safe_join(
      [
        view.tramway_header(headers: %w[Name Email]),
        view.tramway_row do
          view.safe_join(
            [
              view.tramway_cell { 'Alice' },
              view.tramway_cell { 'alice@example.com' }
            ]
          )
        end
      ]
    )
  end
end

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_table' do
    it 'delegates to tramway table component with provided options, size, and block' do
      block = proc {}
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_table(size: :large, class: 'table', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(
        name: 'tramway/table',
        kwargs: { size: :large, options: { class: 'table' } },
        block: block
      )
    end

    it 'defaults to medium size' do
      block = proc {}
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_table(class: 'table', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(
        name: 'tramway/table',
        kwargs: { size: :medium, options: { class: 'table' } },
        block: block
      )
    end

    it 'propagates the current size to nested row and cell helpers' do
      fragment = RENDER_TABLE_FRAGMENT.call(view, size: :small)

      expect(fragment).to include(TABLE_HELPER_SMALL_HEADER_ROW_CLASSES)
      expect(fragment).to include(TABLE_HELPER_SMALL_HEADER_ROW_STYLE)
      expect(fragment).to include(TABLE_HELPER_SMALL_HEADER_CELL_CLASSES)
      expect(fragment).to include(TABLE_HELPER_SMALL_CELL_CLASSES)
    end

    it 'renders the current medium table classes unchanged' do
      fragment = RENDER_TABLE_FRAGMENT.call(view)

      expect(fragment).to include(TABLE_HELPER_MEDIUM_HEADER_ROW_CLASSES)
      expect(fragment).to include(TABLE_HELPER_MEDIUM_HEADER_ROW_STYLE)
      expect(fragment).to include(TABLE_HELPER_MEDIUM_HEADER_CELL_CLASSES)
      expect(fragment).to include(TABLE_HELPER_MEDIUM_CELL_CLASSES)
    end
  end

  describe '#tramway_header' do
    let(:header_block) { proc {} }

    it 'delegates to tramway header component with options' do
      expect(view).to receive(:component).with(
        'tramway/table/header',
        headers: %w[Name Email],
        columns: nil,
        options: { class: 'header' }
      ) do |&received_block|
        expect(received_block).to be header_block
        :header_output
      end

      expect(view.tramway_header(headers: %w[Name Email], class: 'header', &header_block)).to eq :header_output
    end
  end
end
