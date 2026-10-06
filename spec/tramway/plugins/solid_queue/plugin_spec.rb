# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Plugins::SolidQueue::Plugin do
  describe '.ensure_available!' do
    it 'does not raise when the solid_queue gem is available' do
      expect { described_class.ensure_available! }.not_to raise_error
    end

    it 'raises a clear, actionable error when the solid_queue gem cannot be loaded' do
      allow(described_class).to receive(:require).with('solid_queue').and_raise(
        LoadError, 'cannot load such file -- solid_queue'
      )

      expect { described_class.ensure_available! }.to raise_error(
        Tramway::Errors::MissingPluginDependencyError, /solid_queue/
      )
    end
  end

  describe '.nav_item' do
    it 'returns the navbar entry for the configured path' do
      nav_item = described_class.nav_item(Tramway::Plugins::SolidQueue::Config.new(path: '/jobs'))

      expect(nav_item).to include(path: '/jobs')
    end
  end
end
