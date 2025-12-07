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
          scope: :published
        },
        {
          action: 'show'
        },
        {
          action: :create
        }
      ]
    }
  end

  it 'defines routes for each entity in Tramway::Config.entities' do
    expect(get: '/admin/posts').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: build(:entity, **entity_options)
    )

    expect(get: '/admin/comments').to route_to(
      controller: 'tramway/entities',
      action: 'index',
      entity: build(:entity, name: 'comment', namespace: :admin)
    )
  end

  it 'does not define non-existent routes' do
    expect(get: '/non_existing_entity').not_to be_routable
  end
end
