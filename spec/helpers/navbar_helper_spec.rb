# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

shared_examples 'Helpers Navbar' do
  context 'with navbar with items' do
    let(:items) do
      {
        'Users' => '/users',
        'Podcasts' => '/podcasts'
      }
    end

    let(:fragment) do
      view.tramway_navbar do |nav|
        nav.left do
          items.each do |(name, path)|
            nav.item name, path
          end
        end

        nav.right do
          items.each do |(name, path)|
            nav.item name, path
          end
        end
      end
    end

    it 'renders navbar with left and right items' do
      expect(fragment).to have_css(left_items_css, visible: :all)
        .and have_css(right_items_css, visible: :all)

      items.each do |(name, path)|
        expect(fragment).to have_css "#{left_items_css} a[href='#{path}']", visible: :all, text: name
        expect(fragment).to have_css "#{right_items_css} a[href='#{path}']", visible: :all, text: name
      end
    end
  end
end

describe Tramway::Helpers::NavbarHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  let(:title) { Faker::Company.name }

  describe '#tramway_navbar' do
    context 'with success' do
      let(:left_items_css) { 'nav[class*="md:left-0"]' }
      let(:right_items_css) { 'nav[class*="md:left-0"]' }

      it 'renders navbar' do
        fragment = view.tramway_navbar

        expect(fragment).to have_css 'nav', visible: :all
      end

      context 'with title checks' do
        it 'renders navbar with title and default link' do
          fragment = view.tramway_navbar(title:)

          expect(fragment).to have_content title
          expect(fragment).to have_css "a[href='/']", visible: :all
        end

        it 'renders navbar with specific title link' do
          fragment = view.tramway_navbar(title:, title_link: '/home')

          expect(fragment).to have_css "a[href='/home']", visible: :all
        end

        it 'does not renders title in case user did not provide it' do
          fragment = view.tramway_navbar(title_link: '/home')

          expect(fragment).not_to have_css "a[href='/home']"
        end
      end

      context 'with Tramway entities preset' do
        before do
          Tramway.configure do |config|
            config.entities = [:user]
          end
        end

        let(:path) { Rails.application.routes.url_helpers.users_path }
        let(:fragment) { view.tramway_navbar }

        it 'renders the vertical navbar shell with the entity preset' do
          expect(fragment).to have_css 'nav[class*="md:left-0"][class*="md:flex-col"][class*="md:w-64"]', visible: :all
          expect(fragment).to have_css '#desktop-navbar-collapse-button', visible: :all
          expect(fragment).to have_css '#desktop-navbar [data-tramway-navbar-content]', visible: :all
        end

        it_behaves_like 'Helpers Navbar'
      end

      context 'with horizontal direction' do
        let(:fragment) { view.tramway_navbar(direction: :horizontal) }

        it 'renders the horizontal desktop navbar classes' do
          expect(fragment).to have_css 'nav .md\\:justify-between', visible: :all
          expect(fragment).not_to have_css 'nav[class*="md:left-0"]', visible: :all
        end
      end
    end

    context 'with raising errors' do
      it 'raises error in case there are text and block at the same time' do
        expect do
          view.tramway_navbar do |nav|
            nav.right { nav.item('Users', '/users') { 'Users' } }
          end
        end.to raise_error 'You cannot provide an argument and a code block at the same time'
      end
    end
  end
end
