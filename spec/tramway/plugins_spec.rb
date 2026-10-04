# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Plugins do
  describe '.registered?' do
    it 'returns true for a registered plugin' do
      expect(described_class.registered?(:solid_queue)).to be(true)
    end

    it 'returns false for a plugin that was never registered' do
      expect(described_class.registered?(:nonexistent_plugin)).to be(false)
    end
  end

  describe '.fetch' do
    it 'returns the registered plugin class' do
      expect(described_class.fetch(:solid_queue)).to eq(Tramway::Plugins::SolidQueue::Plugin)
    end

    it 'raises a clear error for a plugin that was never registered' do
      expect { described_class.fetch(:nonexistent_plugin) }.to raise_error(
        Tramway::Errors::UnknownPluginError, /nonexistent_plugin/
      )
    end
  end
end
