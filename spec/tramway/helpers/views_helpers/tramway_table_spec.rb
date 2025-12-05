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
    it 'delegates to tailwinds table component with provided options and block' do
      block = proc {}
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_table(class: 'table', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(name: 'tailwinds/table', kwargs: { options: { class: 'table' } }, block: block)
    end
  end
end
