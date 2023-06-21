# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

describe Tramway::Helpers::NavbarHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend Tramway::Helpers::NavbarHelper
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

      it 'renders navbar with tailwind styles' do
        fragment = view.tramway_navbar

        expect(fragment).to have_css 'nav.bg-purple-700.py-4.px-8.flex.justify-between.items-center'
      end

      it 'renders navbar with title' do
        fragment = view.tramway_navbar(title:)

        expect(fragment).to have_content title
      end

      context 'with left and right items checks' do
        let(:left_items_css) { 'nav .flex ul.flex.items-center.space-x-4' }
        let(:right_items_css) { 'nav ul.flex.items-center.space-x-4' }

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

        it 'renders navbar with left and right items' do
          fragment = view.tramway_navbar do |nav|
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

          expect(fragment).to have_css left_items_css
          expect(fragment).to have_css right_items_css

          items.each do |(name, path)|
            expect(fragment).to have_css "#{left_items_css} a[href='#{path}']", text: name
            expect(fragment).to have_css "#{right_items_css} a[href='#{path}']", text: name
          end
        end
      end
    end

    context 'with raising errors' do
      it 'raises error in case there are text and block in the same time' do
        expect do
          view.tramway_navbar do |nav|
            nav.right do
              nav.item 'Users', '/users' do
                'Users'
              end
            end
          end
        end.to(
          raise_error 'You can not provide argument and code block in the same time'
        )
      end
    end
  end
end
