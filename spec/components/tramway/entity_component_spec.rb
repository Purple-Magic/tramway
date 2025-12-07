# frozen_string_literal: true

require 'rails_helper'

describe Tramway::EntityComponent, type: :component do
  let(:entity) { Tramway.config.entities.find { |config| config.name == 'post' } }

  describe '#decorated_item' do
    let(:post) { create :post, aasm_state: :published, title: 'Component Spec Post' }

    it 'decorates the provided item with the entity namespace' do
      component = described_class.new(entity:, item: post)

      expect(component.decorated_item).to be_a(Admin::PostDecorator)
      expect(component.decorated_item.object).to eq(post)
    end
  end

  describe '#href' do
    context 'when the entity defines a show page' do
      let(:post) { create :post, aasm_state: :published }

      it 'builds the show route using the engine helpers' do
        component = described_class.new(entity:, item: post)
        expected_path = Tramway::Engine.routes.url_helpers.admin_post_path(component.decorated_item.id)

        expect(component.href).to eq(expected_path)
      end
    end

    context 'when the entity does not define a show page' do
      let(:entity_without_show) do
        Tramway::Configs::Entity.new(
          name: :post,
          namespace: :admin,
          pages: [Tramway::Configs::Entities::Page.new(action: :index)]
        )
      end
      let(:post) { create :post, aasm_state: :published }

      it 'falls back to the decorated item show_path' do
        allow_any_instance_of(Admin::PostDecorator).to receive(:show_path).and_return('/custom/show/path')

        component = described_class.new(entity: entity_without_show, item: post)

        expect(component.href).to eq('/custom/show/path')
      end
    end
  end

  describe '#cells' do
    let(:post) do
      create :post, aasm_state: :published, title: 'Cells Spec Post'
    end

    it 'returns the decorated index attributes and their values' do
      component = described_class.new(entity:, item: post)

      expect(component.cells).to include(
        title: component.decorated_item.title
      )
    end
  end
end
