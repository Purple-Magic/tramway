# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'
require 'tramway/helpers/views_helper'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_flash' do
    it 'renders flash message with text and resolved color class' do
      fragment = view.tramway_flash text: 'Saved!', type: :success

      expect(fragment).to have_css('.flash.bg-green-700', text: 'Saved!')
    end

    it 'applies custom HTML options to the container' do
      fragment = view.tramway_flash(text: 'Beep!', type: :warning, class: 'mt-4', data: { turbo: 'false' })

      expect(fragment).to have_css('.fixed.top-4.right-4.z-50.space-y-2.mt-4[data-turbo="false"]')
    end
  end
end
