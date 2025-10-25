# frozen_string_literal: true

require 'rails_helper'
require 'tramway/configs/entities/route' # Adjust the path to the Route class

RSpec.describe Tramway::Configs::Entities::Route do
  describe '#helper_method_by' do
    let(:route) { described_class.new(namespace: :admin, route_method: :clients) }

    it 'returns the correct helper method name' do
      expect(route.helper_method_by('custom_name')).to eq('admin_clients_path')
    end

    context 'when route_method is not provided' do
      let(:route) { described_class.new(namespace: :admin) }

      it 'uses the underscored_name as a fallback' do
        expect(route.helper_method_by('custom_name')).to eq('admin_custom_name_path')
      end
    end

    context 'when namespace is not provided' do
      let(:route) { described_class.new(route_method: 'clients') }

      it 'uses the route_method as the method name' do
        expect(route.helper_method_by('custom_name')).to eq('clients_path')
      end
    end

    context 'when both namespace and route_method are not provided' do
      let(:route) { described_class.new }

      it 'uses the underscored_name as a fallback' do
        expect(route.helper_method_by('custom_name')).to eq('custom_name_path')
      end
    end
  end
end
