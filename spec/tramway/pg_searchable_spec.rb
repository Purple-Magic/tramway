# frozen_string_literal: true

require 'rails_helper'
require 'tramway/pg_searchable'

describe Tramway::PgSearchable do
  describe '.call' do
    it 'raises a clear, actionable error when the model is not connected through PostgreSQL' do
      expect { described_class.call(Article, 'Alpha') }
        .to raise_error(Tramway::Errors::UnsupportedDatabaseAdapterError, /PostgreSQL/)
    end
  end

  describe '.ensure_pg_search_scope!' do
    it 'raises a clear, actionable error when the pg_search gem is unavailable' do
      allow(described_class).to receive(:define_pg_search_scope!).and_raise(LoadError,
                                                                            'cannot load such file -- pg_search')

      expect { described_class.ensure_pg_search_scope!(Article) }
        .to raise_error(Tramway::Errors::MissingGemError, /pg_search/)
    end
  end
end
