# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Helpers::RoutesHelper do
  let(:helper_class) do
    Class.new do
      include Tramway::Helpers::RoutesHelper
    end
  end

  let(:helper_instance) { helper_class.new }

  describe '.define_route_helper' do
    it 'defines helpers for every named Tramway route' do
      helper_names = Tramway::Engine.routes.routes.map(&:name).compact.flat_map do |route_name|
        %W[#{route_name}_path #{route_name}_url]
      end

      helper_names.each do |helper_name|
        expect(described_class.instance_methods).to include(helper_name.to_sym)
      end
    end

    it 'delegates route helpers to the Tramway engine url helpers' do
      expect(helper_instance.posts_path).to eq(Tramway::Engine.routes.url_helpers.posts_path)
    end
  end
end
