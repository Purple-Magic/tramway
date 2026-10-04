# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Configs::Plugins do
  subject(:plugins) { described_class.new([:solid_queue]) }

  describe '#include?' do
    it 'returns true for an enabled plugin name' do
      expect(plugins.include?(:solid_queue)).to be(true)
    end

    it 'returns false for a plugin name that was not enabled' do
      expect(plugins.include?(:other_plugin)).to be(false)
    end
  end

  describe '#each' do
    it 'iterates over the enabled plugin names' do
      expect(plugins.to_a).to eq([:solid_queue])
    end
  end

  describe 'per-plugin config' do
    it 'returns a default config for an enabled plugin that was not explicitly configured' do
      expect(plugins.solid_queue.path).to eq('/jobs')
    end

    it 'stores an explicitly assigned config for an enabled plugin' do
      plugins.solid_queue = { path: '/background_jobs' }

      expect(plugins.solid_queue.path).to eq('/background_jobs')
    end

    it 'does not intercept methods that are not registered plugin names' do
      expect { plugins.unknown_plugin }.to raise_error(NoMethodError)
    end
  end
end
