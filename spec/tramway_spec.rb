# frozen_string_literal: true

# tramway_spec.rb

require 'rails_helper'

RSpec.describe Tramway do
  let(:config) { Tramway::Config.instance }

  describe '.configure' do
    it 'yields to the configuration block' do
      expect { |block| described_class.configure(&block) }.to yield_control
    end

    it 'calls the block with the config object' do
      expect { |block| described_class.configure(&block) }.to yield_with_args(config)
    end
  end

  describe '.config' do
    it 'returns the Tramway::Config instance' do
      expect(described_class.config).to eq(config)
    end
  end
end
