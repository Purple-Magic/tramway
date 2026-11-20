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
    it 'renders the flash with the variant resolved from the type' do
      fragment = view.tramway_flash text: 'Saved!', type: :success

      expect(fragment).to have_css('.flash.tramway-flash.tramway-flash--success', text: 'Saved!')
    end

    it 'renders the neutral flash for the default type' do
      fragment = view.tramway_flash text: 'Saved!', type: :default

      expect(fragment).to have_css('.flash.tramway-flash.tramway-flash--secondary', text: 'Saved!')
    end

    it 'falls back to a tinted flash for an explicit Tailwind color' do
      fragment = view.component 'tramway/flash', text: 'Saved!', color: :violet

      expect(fragment).to have_css('.flash.tramway-flash--tint.tramway-tint--violet', text: 'Saved!')
    end

    it 'applies custom HTML options to the container' do
      fragment = view.tramway_flash(text: 'Beep!', type: :warning)

      expect(fragment).to have_css('.tramway-flash-container')
    end

    it 'renders the flash text role' do
      fragment = view.tramway_flash(text: 'Beep!', type: :warning)

      expect(fragment).to have_css('.tramway-flash__text', text: 'Beep!')
    end
  end
end
