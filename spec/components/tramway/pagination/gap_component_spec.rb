# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Pagination::GapComponent, type: :component do
  it 'uses the pagination gap primitive' do
    component = described_class.new

    expect(component.gap_classes).to eq(
      'page gap tramway-pagination__gap'
    )
  end
end
