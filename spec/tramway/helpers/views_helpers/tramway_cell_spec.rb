# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_cell' do
    let(:cell_block) { proc {} }

    it 'delegates to tramway cell component' do
      expect(view).to receive(:component).with('tramway/table/cell') do |&received_block|
        expect(received_block).to be cell_block
        :cell_output
      end

      expect(view.tramway_cell(&cell_block)).to eq :cell_output
    end
  end
end
