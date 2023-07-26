# frozen_string_literal: true

# tramway_spec.rb

require 'rails_helper'

RSpec.describe Tramway do
  let(:config) { Tramway::Config.instance }

  describe '.configure' do
    it 'yields to the configuration block' do
      expect { |block| Tramway.configure(&block) }.to yield_control
    end

    it 'calls the block with the config object' do
      expect { |block| Tramway.configure(&block) }.to yield_with_args(config)
    end
  end

  describe '.config' do
    it 'returns the Tramway::Config instance' do
      allow(Tramway::Config).to receive(:instance).and_return(config)
      expect(Tramway.config).to eq(config)
    end
  end
end
