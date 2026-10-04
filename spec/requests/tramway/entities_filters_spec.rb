# frozen_string_literal: true

require 'rails_helper'

describe 'Entities Filters', type: :request do
  before do
    Comment.destroy_all

    create(:comment, text: 'Hello world')
    create(:comment, text: '')
  end

  context 'when filters are configured for the page' do
    it 'applies the matching scope on top of the index listing when params[:filter] is given' do
      get '/admin/comments', params: { filter: 'with_text' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Hello world')
    end

    it 'shows a clear error when params[:filter] does not match any configured filter' do
      get '/admin/comments', params: { filter: 'unknown_filter' }

      expect(response.body).to include('Tramway::Errors::InvalidFilterError')
      expect(response.body).to include('unknown filter "unknown_filter"')
      expect(response.body).to include('with_text, without_text')
    end

    it 'renders the configured filters with their counts' do
      get '/admin/comments'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('WITH_TEXT')
      expect(response.body).to include('WITHOUT_TEXT')
    end

    it 'renders a working toggle button wired to the collapsible controller' do
      get '/admin/comments'

      expect(response.body).to include('data-action="tramway--collapsible#toggle"')
      expect(response.body).to include('data-tramway--collapsible-target="toggle"')
      expect(response.body).not_to include('options="{')
    end
  end

  context 'when filters are not configured for the page' do
    it 'ignores params[:filter] instead of calling an arbitrary scope' do
      Article.destroy_all
      create(:article, title: 'Alpha')

      get '/admin/articles', params: { filter: 'destroy_all' }

      expect(response).to have_http_status(:ok)
      expect(Article.count).to eq(1)
    end
  end
end
