# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'
require 'tramway/helpers/views_helper'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_tooltip' do
    it 'delegates to tramway tooltip component with options and block' do
      block = proc {}
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_tooltip(text: 'Helpful text', event: :onclick, class: 'ml-4', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(
        name: 'tramway/tooltip',
        kwargs: { text: 'Helpful text', event: :onclick, options: { class: 'ml-4' } },
        block:
      )
    end
  end
end
