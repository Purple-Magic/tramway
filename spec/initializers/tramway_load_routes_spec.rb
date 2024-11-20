# frozen_string_literal: true

describe 'Tramway::Engine load_routes initializer', type: :routing do
  it 'defines routes for each entity in Tramway::Config.entities' do
    expect(get: '/admin/podcasts').to route_to(controller: 'tramway/entities', action: 'index')
    expect(get: '/admin/users').to route_to(controller: 'tramway/entities', action: 'index')
  end

  it 'does not define non-existent routes' do
    expect(get: '/non_existing_entity').not_to be_routable
  end
end
