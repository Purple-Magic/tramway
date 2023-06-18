# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

describe Tramway::Helpers::NavbarHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend Tramway::Helpers::NavbarHelper
  end

  let(:brand) { Faker::Company.name }
  let(:items) do
    {
      'Users' => '/users',
      'Podcasts' => '/podcasts'
    }
  end

  describe '#tramway_navbar' do
    it 'renders navbar with tailwind styles' do
      fragment = view.tramway_navbar

      expect(fragment).to have_css 'nav.bg-red-500.py-4.px-8.flex.justify-between.items-center'
    end

    it 'renders navbar with brand' do
      fragment = view.tramway_navbar(brand:)

      expect(fragment).to have_content brand
    end

    it 'renders navbar with left items' do
      fragment = view.tramway_navbar do |nav|
        nav.left do
          items.each do |(name, path)|
            nav.item name, path
          end
        end
      end

      expect(fragment).to have_css 'nav .flex ul.flex.items-center.space-x-4'

      items.each do |(name, path)|
        expect(fragment).to have_css "a[href='#{path}']", text: name
      end
    end

    # context 'with raising errors' do
    #   it 'raises error in case there are text and block in the same time' do
    #     expect { view.tramway_navbar(text, path, &block) }.to(
    #       raise_error 'You can not provide argument and code block in the same time'
    #     )
    #   end
    # end
  end
end
