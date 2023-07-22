# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Config do
  let(:config) { Tramway::Config.instance }

  describe '#entities=' do
    context 'when collection is not empty' do
      let(:entities) { %w[Podcast Episode] }

      before do
        config.entities = entities
      end

      it 'sets entities as an array of Tramway::Configs::Entity objects' do
        expect(config.entities).to be_an(Array)
        expect(config.entities.length).to eq(entities.length)

        config.entities.each do |entity|
          expect(entity).to be_a(Tramway::Configs::Entity)
        end
      end
    end
  end

  describe '#entities' do
    context 'with empty collection' do
      before do
        config.entities = []
      end

      it 'returns an empty array if no entities have been set' do
        expect(config.entities).to eq([])
      end
    end

    context 'with non-empty collection' do
      let(:entities) { %w[Podcast Episode] }

      before do
        config.entities = entities
      end

      it 'returns the previously set entities' do
        expect(config.entities.map(&:name)).to eq(entities)
      end
    end
  end
end
