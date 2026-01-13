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
    shared_examples 'flash theme classes' do |theme_classes|
      it 'renders flash message with text and resolved color class' do
        fragment = view.tramway_flash text: 'Saved!', type: :success

        expect(fragment).to have_css(".flash.#{class_selector(theme_classes)}", text: 'Saved!')
      end
    end

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'flash theme classes', %w[bg-green-700 text-white]
    end

    context 'with neomorphism theme' do
      around { |example| with_theme(:neomorphism) { example.run } }

      it_behaves_like 'flash theme classes', %w[bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100]
    end

    it 'applies custom HTML options to the container' do
      fragment = view.tramway_flash(text: 'Beep!', type: :warning, class: 'mt-4', data: { turbo: 'false' })

      expect(fragment).to have_css('.fixed.top-4.right-4.z-50.space-y-2.mt-4[data-turbo="false"]')
    end
  end
end
