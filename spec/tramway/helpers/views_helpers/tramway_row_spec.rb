# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_row' do
    let(:row_block) { proc {} }
    let(:row_component_arguments) do
      { cells: %w[first second], href: '/rows/1', options: { class: 'row' } }
    end
    let(:row_helper_arguments) { { cells: %w[first second], href: '/rows/1', class: 'row' } }

    it 'delegates to tailwinds row component with extracted options' do
      expect(view).to receive(:component).with('tailwinds/table/row', **row_component_arguments) do |&received_block|
        expect(received_block).to be row_block
        :row_output
      end

      expect(view.tramway_row(**row_helper_arguments, &row_block)).to eq :row_output
    end
  end
end
