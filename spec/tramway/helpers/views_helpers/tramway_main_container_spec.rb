# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'
require 'tramway/helpers/views_helper'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_main_container' do
    it 'renders the shared main container id by default' do
      fragment = view.tramway_main_container do
        'Content'
      end

      expect(fragment).to have_css('#tramway-main-container')
    end

    it 'keeps a caller supplied id when present' do
      fragment = view.tramway_main_container(id: 'custom-main-container') do
        'Content'
      end

      expect(fragment).to have_css('#custom-main-container')
    end
  end
end
