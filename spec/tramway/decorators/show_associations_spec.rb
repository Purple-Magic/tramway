# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Decorators::ShowAssociations do
  describe '#__show_associations' do
    subject(:new_record_path) { context.decorator.send(:__show_associations, nil).first[:new_record_path] }

    before do
      stub_entities(context)
      stub_route_helpers(context.post.id)
    end

    let(:context) { build_context(show_association_options:) }
    let(:show_association_options) { nil }

    it 'finds the association entity by the reflection class name instead of the association name' do
      expect(new_record_path).to eq("/admin/comments/new?redirect=%2Fadmin%2Fposts%2F#{context.post.id}")
    end

    context 'when the association config provides a custom new record path' do
      let(:show_association_options) { { new_record_path: '/custom/comments/new?source=post' } }

      it 'uses the custom path and appends the entity show redirect' do
        expect(new_record_path).to eq("/custom/comments/new?source=post&redirect=%2Fadmin%2Fposts%2F#{context.post.id}")
      end
    end

    context 'when the associated entity has no create page' do
      before do
        allow(context.comment_entity).to receive(:page).with(:create).and_return(nil)
      end

      it 'does not build a new record path' do
        expect(new_record_path).to be_nil
      end
    end

    context 'when the current entity has no show page' do
      before do
        allow(context.post_entity).to receive(:page).with(:show).and_return(nil)
      end

      it 'keeps the new record path without a redirect' do
        expect(new_record_path).to eq('/admin/comments/new')
      end
    end

    def build_context(show_association_options:)
      user = create :user
      post = create(:post, user:)
      create(:comment, post:, user:)

      test_context(
        decorator: build_decorator_class(show_association_options).new(post),
        post:,
        comment_entity: build_comment_entity,
        post_entity: build_post_entity
      )
    end

    def test_context(...)
      Struct.new(:decorator, :post, :comment_entity, :post_entity, keyword_init: true).new(...)
    end

    def stub_entities(context)
      allow(Tramway.config).to receive(:entities).and_return([context.comment_entity, context.post_entity])
      stub_entity_pages(context)
    end

    def stub_entity_pages(context)
      allow(context.comment_entity).to receive(:page).with(:create).and_return(true)
      allow(context.post_entity).to receive(:page).with(:show).and_return(true)
    end

    def stub_route_helpers(post_id)
      allow(Tramway::Engine.routes.url_helpers).to receive(:public_send)
        .with('new_admin_comment_path')
        .and_return('/admin/comments/new')
      allow(Tramway::Engine.routes.url_helpers).to receive(:public_send)
        .with('admin_post_path', post_id)
        .and_return("/admin/posts/#{post_id}")
    end

    def build_decorator_class(show_association_options)
      Class.new(Tramway::BaseDecorator) do
        association :responses, decorator: Admin::CommentDecorator

        define_method(:show_associations) do
          if show_association_options.present?
            [[:responses, show_association_options]]
          else
            %i[responses]
          end
        end
      end
    end

    def build_comment_entity
      instance_double(
        Tramway::Configs::Entity,
        name: 'comment',
        new_helper_method: 'new_admin_comment_path'
      )
    end

    def build_post_entity
      instance_double(
        Tramway::Configs::Entity,
        name: 'post',
        show_helper_method: 'admin_post_path'
      )
    end
  end
end
