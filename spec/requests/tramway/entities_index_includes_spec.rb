# frozen_string_literal: true

require 'rails_helper'

describe 'Entities Index Includes', type: :request do
  def count_queries(matching: nil)
    count = 0

    subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |_name, _start, _finish, _id, payload|
      next if payload[:name] == 'SCHEMA' || payload[:sql].start_with?('SAVEPOINT', 'RELEASE')
      next if matching && !payload[:sql].match?(matching)

      count += 1
    end

    yield

    count
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  context 'without includes configured' do
    before do
      Article.destroy_all

      create_list :article, 3
    end

    it 'issues the same query count as before includes support was added' do
      total_queries = count_queries { get '/admin/articles' }

      expect(response).to have_http_status(:ok)
      expect(total_queries).to eq(2)
    end
  end

  context 'with includes configured alongside an existing scope' do
    before do
      Post.destroy_all

      create_list(:post, 3).each { |post| post.update! aasm_state: :published }
    end

    it 'preloads the association with a single query instead of one query per row' do
      user_queries = count_queries(matching: /SELECT.*FROM\s+"?users"?/i) { get '/admin/posts' }

      expect(response).to have_http_status(:ok)
      expect(user_queries).to eq(1)
    end
  end
end
