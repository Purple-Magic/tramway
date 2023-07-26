# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'
require 'helpers/navbar/shared_examples'

describe Tramway::Helpers::NavbarHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  let(:title) { Faker::Company.name }

  describe '#tramway_navbar' do
    context 'with success' do
      let(:items) do
        {
          'Users' => '/users',
          'Podcasts' => '/podcasts'
        }
      end

      let(:left_items_css) { 'nav .flex ul.flex.items-center.space-x-4' }
      let(:right_items_css) { 'nav ul.flex.items-center.space-x-4' }

      it 'renders navbar with tailwind styles' do
        fragment = view.tramway_navbar

        expect(fragment).to have_css 'nav.bg-purple-700.py-4.px-8.flex.justify-between.items-center'
      end

      context 'with title checks' do
        it 'renders navbar with title and default link' do
          fragment = view.tramway_navbar(title:)

          expect(fragment).to have_content title
          expect(fragment).to have_css "a[href='/']"
        end

        it 'renders navbar with specific title link' do
          fragment = view.tramway_navbar(title:, title_link: '/home')

          expect(fragment).to have_css "a[href='/home']"
        end

        it 'does not renders title in case user did not provide it' do
          fragment = view.tramway_navbar(title_link: '/home')

          expect(fragment).not_to have_css "a[href='/home']"
        end
      end

      context 'with left and right items checks' do
        it 'renders navbar with left items' do
          fragment = view.tramway_navbar do |nav|
            nav.left do
              items.each do |(name, path)|
                nav.item name, path
              end
            end
          end

          expect(fragment).to have_css left_items_css

          items.each do |(name, path)|
            expect(fragment).to have_css "a[href='#{path}']", text: name
          end
        end

        it 'renders navbar with right items' do
          fragment = view.tramway_navbar do |nav|
            nav.right do
              items.each do |(name, path)|
                nav.item name, path
              end
            end
          end

          expect(fragment).to have_css right_items_css

          items.each do |(name, path)|
            expect(fragment).to have_css "a[href='#{path}']", text: name
          end
        end

        include_examples 'Helpers Navbar'
      end

      context 'with Tramway entities preset' do
        before do
          Tramway.configure do |config|
            config.entities = [:user]
          end
        end

        let(:path) { Rails.application.routes.url_helpers.users_path }
        let(:fragment) { view.tramway_navbar }

        it 'renders navbar with users link on the left' do
          expect(fragment).to have_css "#{left_items_css} a[href='#{path}']", text: 'Users'
        end

        include_examples 'Helpers Navbar'
      end
    end

    context 'with raising errors' do
      it 'raises error in case there are text and block at the same time' do
        expect do
          view.tramway_navbar do |nav|
            nav.right do
              nav.item 'Users', '/users' do
                'Users'
              end
            end
          end
        end.to(
          raise_error 'You cannot provide an argument and a code block at the same time'
        )
      end
    end
  end
end
