# frozen_string_literal: true

require 'rails_helper'

describe 'Tramway::Engine load_routes initializer', type: :routing do
  let(:entity_options) do
    {
      name: 'post',
      namespace: :admin,
      pages: [
        {
          action: 'index',
          scope: :published,
          search: true
        },
        {
          action: 'show'
        },
        {
          action: :create
        },
        {
          action: :update
        },
        {
          action: :destroy
        }
      ]
    }
  end

  it 'defines routes for each entity in Tramway::Config.entities' do
    expect(get: '/admin/posts').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: { 'name' => 'admin:post' }
    )

    expect(get: '/admin/comments').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: { 'name' => 'admin:comment' }
    )
  end

  it 'does not define non-existent routes' do
    expect(get: '/non_existing_entity').not_to be_routable
  end
end
