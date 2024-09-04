# frozen_string_literal: true

shared_examples 'Tramway Config Entity human_name' do |name|
  subject { described_class.new(name:) }

  describe '#human_name' do
    let(:expected_plural_name) { name.to_s.pluralize.capitalize }
    let(:expected_single_name) { name.to_s.capitalize }

    it 'returns an HumanNameStruct object with single and plural human names' do
      expect(subject.human_name).to be_an(Tramway::Configs::Entity::HumanNameStruct)
      expect(subject.human_name).to respond_to(:single)
      expect(subject.human_name).to respond_to(:plural)
    end

    it 'sets the correct single and plural human names' do
      expect(subject.human_name.single).to eq(expected_single_name)
      expect(subject.human_name.plural).to eq(expected_plural_name)
    end
  end
end

shared_examples 'Tramway Config Entity routes' do
  describe '#routes' do
    it 'returns an RouteStruct object with index route' do
      expect(subject.routes).to be_an(Tramway::Configs::Entity::RouteStruct)
      expect(subject.routes).to respond_to(:index)
    end

    it 'sets the correct index route' do
      expect(subject.routes.index).to eq(Rails.application.routes.url_helpers.public_send(helper))
    end
  end
end

describe Tramway::Configs::Entity do
  context 'with entity name' do
    context 'with entity without namespaces' do
      entity = :user

      include_examples 'Tramway Config Entity human_name', entity
    end

    context 'with entity with namespaces' do
      entity = 'episodes/part'

      include_examples 'Tramway Config Entity human_name', entity
    end
  end

  context 'with entity name and route contains namespace only' do
    subject { described_class.new(name:, route:) }

    let(:name) { :user }
    let(:route) { { namespace: :admin } }

    let(:helper) { "#{route[:namespace]}_#{name.to_s.pluralize}_path" }

    include_examples 'Tramway Config Entity routes'
  end

  context 'with entity name and route contains namespace and route_method' do
    subject { described_class.new(name:, route:) }

    let(:name) { :user }
    let(:route) { { namespace: :admin, route_method: :clients } }

    let(:helper) { "#{route[:namespace]}_#{route[:route_method]}_path" }

    include_examples 'Tramway Config Entity routes'
  end

  context 'with entity name and route contains route_method only' do
    subject { described_class.new(name:, route:) }

    let(:name) { :user }
    let(:route) { { route_method: :clients } }

    let(:helper) { "#{route[:route_method]}_path" }

    include_examples 'Tramway Config Entity routes'
  end
end
