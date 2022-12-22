# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tramway do
  it 'defined tramway module' do
    expect(defined?(described_class)).to be_truthy
  end
end
