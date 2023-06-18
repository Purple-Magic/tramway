# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

describe Tramway::Helpers::NavbarHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend Tramway::Helpers::NavbarHelper
  end

  let(:brand) { Faker::Company.name }

  describe '#tramway_navbar' do
    it 'renders navbar with tailwind styles' do
      fragment = view.tramway_navbar

      expect(fragment).to have_css 'nav.bg-red-500.py-4.px-8.flex.justify-between.items-center'
    end

    it 'renders navbar with brand' do
      fragment = view.tramway_navbar(brand:)

      expect(fragment).to have_content brand
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
