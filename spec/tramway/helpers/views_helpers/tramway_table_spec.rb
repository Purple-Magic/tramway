# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_table' do
    it 'delegates to tramway table component with provided options and block' do
      block = proc {}
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_table(class: 'table', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(name: 'tramway/table', kwargs: { options: { class: 'table' } }, block: block)
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
