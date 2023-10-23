# frozen_string_literal: true

shared_examples 'Tramway Config Entity human_name' do |name|
  subject { described_class.new(name:) }

  describe '#human_name' do
    it 'returns an OpenStruct object with single and plural human names' do
      expect(subject.human_name).to be_an(OpenStruct)
      expect(subject.human_name).to respond_to(:single)
      expect(subject.human_name).to respond_to(:plural)
    end

    let(:expected_single_name) { name.to_s.capitalize }
    let(:expected_plural_name) { name.to_s.pluralize.capitalize }

    it 'sets the correct single and plural human names' do
      expect(subject.human_name.single).to eq(expected_single_name)
      expect(subject.human_name.plural).to eq(expected_plural_name)
    end
  end
end

shared_examples 'Tramway Config Entity routes' do
  describe '#routes' do
    it 'returns an OpenStruct object with index route' do
      expect(subject.routes).to be_an(OpenStruct)
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
    let(:name) { :user }
    let(:route) { { namespace: :admin } }

    subject { described_class.new(name:, route:) }

    let(:helper) { "#{route[:namespace]}_#{name.to_s.pluralize}_path" }

    include_examples 'Tramway Config Entity routes'
  end

  context 'with entity name and route contains namespace and route_method' do
    let(:name) { :user }
    let(:route) { { namespace: :admin, route_method: :clients } }

    subject { described_class.new(name:, route:) }

    let(:helper) { "#{route[:namespace]}_#{route[:route_method]}_path" }

    include_examples 'Tramway Config Entity routes'
  end

  context 'with entity name and route contains route_method only' do
    let(:name) { :user }
    let(:route) { { route_method: :clients } }

    subject { described_class.new(name:, route:) }

    let(:helper) { "#{route[:route_method]}_path" }

    include_examples 'Tramway Config Entity routes'
  end
end
