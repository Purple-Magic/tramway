# frozen_string_literal: true

require 'rails_helper'

describe Tramway::BackButtonComponent, type: :component do
  before do
    allow(I18n).to receive(:t).and_call_original
    allow(I18n).to receive(:t).with('actions.back').and_return('Back')
  end

  shared_examples 'back button classes' do |expected_classes|
    it 'renders link with back classes and translation' do
      render_inline(described_class.new)

      expect(page).to have_css "a[href='#']", text: 'Back'
      expect(page).to have_css(
        "a.#{class_selector(expected_classes)}"
      )
      expect(page).to have_css "a[onclick='window.history.back(); return false;']"
    end
  end

  context 'with the default classes' do
    it_behaves_like 'back button classes', %w[tramway-button tramway-button--secondary ml-2]
  end
end
