# frozen_string_literal: true

require 'rails_helper'

describe 'Entities Custom Pages', type: :request do
  describe 'a collection-level custom page (no member: true)' do
    it 'routes to the host app controller and renders it with the Tramway layout/navbar' do
      create(:post)

      get '/admin/posts/stats'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Total posts')
      expect(response.body).to include('tramway-main-container')
    end
  end

  describe 'a member-level custom page (member: true) with extra path params' do
    it 'exposes both the record id and the declared param to the host app controller/view' do
      post_record = create(:post)

      get "/admin/posts/#{post_record.id}/export/csv"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post_record.id.to_s)
      expect(response.body).to include('csv')
    end

    it 'accepts every HTTP method configured via via:' do
      post_record = create(:post)

      post "/admin/posts/#{post_record.id}/export/csv"

      expect(response).to have_http_status(:ok)
    end

    it 'does not match an HTTP method that was not configured via via:' do
      post_record = create(:post)

      patch "/admin/posts/#{post_record.id}/export/csv"

      expect(response).to have_http_status(:not_found)
    end
  end
end
