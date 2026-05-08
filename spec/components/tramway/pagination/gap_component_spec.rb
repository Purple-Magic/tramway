# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Pagination::GapComponent, type: :component do
  it 'uses hardcoded dark pagination classes' do
    component = described_class.new

    expect(component.gap_classes).to eq(
      'page gap hidden items-center justify-center px-3 py-2 text-sm font-medium text-zinc-500 sm:flex'
    )
  end
end
