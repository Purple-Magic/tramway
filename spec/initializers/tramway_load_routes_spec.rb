# frozen_string_literal: true

require 'rails_helper'

describe 'Tramway::Engine load_routes initializer', type: :routing do
  it 'defines routes for each entity in Tramway::Config.entities' do
    expect(get: '/admin/posts').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: build(:entity, name: 'post', pages: [{ action: 'index', scope: :published }, { action: 'show' }])
    )

    expect(get: '/admin/comments').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: build(:entity, name: 'comment')
    )
  end

  it 'does not define non-existent routes' do
    expect(get: '/non_existing_entity').not_to be_routable
  end

  it 'merges actions from existing project routes with entity actions' do
    expect(get: '/admin/articles').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: build(:entity, name: 'article')
    )

    expect(get: '/admin/articles/1').to route_to(
      controller: 'tramway/entities',
      action: 'show',
      id: '1',
      entity: build(:entity, name: 'article')
    )

    expect(get: '/admin/articles/feed').not_to be_routable
  end
end
