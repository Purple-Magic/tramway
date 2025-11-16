# frozen_string_literal: true

require 'rails_helper'

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
      expect(subject.routes).to respond_to(:show)
    end

    it 'sets the correct routes' do
      expect(subject.routes.index).to eq(index_helper)
      expect(subject.routes.show).to eq(show_helper)
    end
  end
end

shared_examples 'Tramway Config Entity routes absent' do
  describe '#routes' do
    it 'responds with RouteStruct' do
      expect(subject.routes).to be_an(Tramway::Configs::Entity::RouteStruct)
      expect(subject.routes).to respond_to(:index)
      expect(subject.routes).to respond_to(:show)
    end

    it 'sets the correct index route' do
      expect(subject.routes.index).to be_nil
      expect(subject.routes.show).to be_nil
    end
  end
end

describe Tramway::Configs::Entity do
  context 'with entity name' do
    context 'with entity without namespaces' do
      it_behaves_like 'Tramway Config Entity human_name', :user
    end

    context 'with entity with namespaces' do
      it_behaves_like 'Tramway Config Entity human_name', 'episodes/part'
    end
  end

  context 'with entity name and route contains namespace only' do
    subject do
      described_class.new(name:, namespace:, pages: [{ action: :index }, { action: :show }])
    end

    let(:name) { :post }
    let(:namespace) { :admin }

    let(:index_helper) { "#{namespace}_#{name.to_s.pluralize}_path" }
    let(:show_helper) { "#{namespace}_#{name}_path" }

    it_behaves_like 'Tramway Config Entity routes'
  end

  context 'with page index' do
    context 'with entity name and route contains namespace and route_method' do
      subject { described_class.new(name:, namespace:, route:, pages: [{ action: :index }, { action: :show }]) }

      let(:name) { :post }
      let(:route) { { route_method: :clients } }
      let(:namespace) { :admin }

      let(:index_helper) { "#{namespace}_#{route[:route_method]}_path" }
      let(:show_helper) { "#{namespace}_#{route[:route_method]}_path" }

      it_behaves_like 'Tramway Config Entity routes'
    end

    context 'with entity name and route contains route_method only' do
      subject { described_class.new(name:, route:, pages: [{ action: :index }, { action: :show }]) }

      let(:name) { :post }
      let(:route) { { route_method: :clients } }

      let(:index_helper) { "#{route[:route_method]}_path" }
      let(:show_helper) { "#{route[:route_method]}_path" }

      it_behaves_like 'Tramway Config Entity routes'
    end
  end

  context 'with page index only' do
    subject { described_class.new(name:, pages: [{ action: :index }]) }

    let(:name) { :post }

    it 'does not expose show route' do
      expect(subject.routes.show).to be_nil
    end
  end

  context 'without page index' do
    context 'with entity name and route contains namespace and route_method' do
      subject { described_class.new(name:, namespace:, route:) }

      let(:name) { :post }
      let(:route) { { route_method: :clients } }
      let(:namespace) { :admin }

      let(:helper) { "#{namespace}_#{route[:route_method]}_path" }

      it_behaves_like 'Tramway Config Entity routes absent'
    end

    context 'with entity name and route contains route_method only' do
      subject { described_class.new(name:, route:) }

      let(:name) { :post }
      let(:route) { { route_method: :clients } }

      let(:helper) { "#{route[:route_method]}_path" }

      it_behaves_like 'Tramway Config Entity routes absent'
    end
  end
end
