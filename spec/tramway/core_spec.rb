# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tramway::Core do
  it 'defined core module' do
    expect(defined?(Tramway::Core)).to be_truthy
  end
end
