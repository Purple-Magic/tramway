# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/decorate_helper'

describe Tramway::EntityComponent, type: :component do
  include Tramway::Helpers::DecorateHelper

  let(:entity) { Tramway.config.entities.find { |config| config.name == 'post' } }

  describe '#href' do
    let(:post) do
      tramway_decorate create(:post, aasm_state: :published), namespace: entity.namespace
    end

    context 'when the entity defines a show page' do
      it 'builds the show route using the engine helpers' do
        component = described_class.new(entity:, item: post)
        expected_path = Tramway::Engine.routes.url_helpers.admin_post_path(component.item.id)

        expect(component.href).to eq(expected_path)
      end
    end

    context 'when the entity does not define a show page' do
      let(:entity) do
        Tramway::Configs::Entity.new(
          name: :post,
          namespace: :admin,
          pages: [Tramway::Configs::Entities::Page.new(action: :index)]
        )
      end

      it 'falls back to the item show_path' do
        allow_any_instance_of(Admin::PostDecorator).to receive(:show_path).and_return('/custom/show/path')

        component = described_class.new(entity:, item: post)

        expect(component.href).to eq('/custom/show/path')
      end
    end
  end

  describe '#cells' do
    let(:post) do
      tramway_decorate create(:post, aasm_state: :published, title: 'Cells Spec Post'), namespace: entity.namespace
    end

    it 'returns the decorated index attributes and their values' do
      component = described_class.new(entity:, item: post)

      expect(component.cells).to include(
        title: component.item.title
      )
    end
  end
end
