# frozen_string_literal: true

require 'rails_helper'

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

shared_examples 'Tramway Config Entity routes' do |name, route|
  subject { described_class.new(name:, route:) }

  describe '#routes' do
    it 'returns an OpenStruct object with index route' do
      expect(subject.routes).to be_an(OpenStruct)
      expect(subject.routes).to respond_to(:index)
    end

    let(:expected_route) do
      helper = if route.present?
                 if route[:namespace].present? && route[:route_method].nil?
                   "#{route[:namespace]}_#{name.to_s.pluralize.parameterize.underscore}_path"
                 elsif route[:namespace].present? && route[:route_method].present?
                   "#{route[:namespace]}_#{route[:route_method]}_path"
                 elsif route[:namespace].nil? && route[:route_method].present?
                   "#{route[:route_method]}_path"
                 end
               else
                 "#{name.to_s.pluralize.parameterize.underscore}_path"
               end

      Rails.application.routes.url_helpers.public_send helper
    end

    it 'sets the correct index route' do
      expect(subject.routes.index).to eq(expected_route)
    end
  end
end

describe Tramway::Configs::Entity do
  context 'with entity name' do
    context 'with entity without namespaces' do
      entity = :user

      include_examples 'Tramway Config Entity human_name', entity
      include_examples 'Tramway Config Entity routes', entity
    end

    context 'with entity with namespaces' do
      entity = 'episodes/part'

      include_examples 'Tramway Config Entity human_name', entity
      include_examples 'Tramway Config Entity routes', entity
    end
  end

  context 'with entity name and route contains namespace only' do
    include_examples 'Tramway Config Entity routes', :user, { namespace: :admin }
  end

  context 'with entity name and route contains namespace and route_method' do
    include_examples 'Tramway Config Entity routes', :user, { namespace: :admin, route_method: :clients }
  end

  context 'with entity name and route contains route_method only' do
    include_examples 'Tramway Config Entity routes', :user, { route_method: :clients }
  end
end
