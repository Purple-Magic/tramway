describe 'Tramway::Engine load_routes initializer', type: :routing do
  it 'defines routes for each entity in Tramway::Config.entities' do
    expect(get: '/tramway/podcasts').to route_to(controller: 'tramway/entities', action: 'index')
    # expect(get: '/tramway/users').to be_routable
  end

  it 'does not define non-existent routes' do
    expect(get: '/non_existing_entity').not_to be_routable
  end
end
