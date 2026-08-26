# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'
require 'tramway/helpers/views_helper'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_grid' do
    it 'defaults outline to false when not provided' do
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_grid(rows: 2, columns: 3, class: 'dashboard-grid')

      expect(result).to eq :component_output
      expect(captured).to eq(
        name: 'tramway/grid',
        kwargs: { rows: 2, columns: 3, outline: false, options: { class: 'dashboard-grid' } },
        block: nil
      )
    end

    it 'delegates to the grid component with provided rows, columns, outline, options and block' do
      block = proc {}
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_grid(rows: 8, columns: 8, outline: true, class: 'dashboard-grid', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(
        name: 'tramway/grid',
        kwargs: { rows: 8, columns: 8, outline: true, options: { class: 'dashboard-grid' } },
        block: block
      )
    end
  end

  describe '#tramway_card' do
    it 'delegates to the grid card component with a size and options' do
      block = proc {}

      expect(view)
        .to receive(:component)
        .with('tramway/grid/card', size: [1, 2], options: { class: 'card' })
        .and_return(:card_output)

      expect(view.tramway_card(size: [1, 2], class: 'card', &block)).to eq :card_output
    end
  end
end
