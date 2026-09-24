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
end
