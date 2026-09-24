# frozen_string_literal: true

require 'rails_helper'

describe 'Entities Search', type: :request do
  it 'surfaces a clear developer-facing error when searching a model on a non-PostgreSQL database' do
    Article.destroy_all
    create(:article, title: 'Alpha article')

    get '/admin/articles', params: { query: 'Alpha' }

    expect(response.body).to include('Tramway::Errors::UnsupportedDatabaseAdapterError')
    expect(response.body).to include('requires PostgreSQL')
  end
end
