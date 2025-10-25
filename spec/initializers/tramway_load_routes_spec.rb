# frozen_string_literal: true

require 'rails_helper'
describe 'Tramway::Engine load_routes initializer', type: :routing do
  it 'defines routes for each entity in Tramway::Config.entities' do
    expect(get: '/admin/posts').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: build(:entity, name: 'post', pages: [{ action: 'index', scope: :published }])
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
end
