# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::Core::TitleHelper do
  it 'defined helper module' do
    expect(defined?(described_class)).to be_truthy
  end
end
