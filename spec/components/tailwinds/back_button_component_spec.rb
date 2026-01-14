# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::BackButtonComponent, type: :component do
  before do
    allow(I18n).to receive(:t).and_call_original
    allow(I18n).to receive(:t).with('actions.back').and_return('Back')
  end

  shared_examples 'back button theme classes' do |theme_classes|
    it 'renders link with back classes and translation' do
      render_inline(described_class.new)

      expect(page).to have_css "a[href='#']", text: 'Back'
      expect(page).to have_css(
        "a.#{class_selector(theme_classes)}"
      )
      expect(page).to have_css "a[onclick='window.history.back(); return false;']"
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    it_behaves_like 'back button theme classes',
                    %w[
                      btn btn-delete bg-orange-100 hover:bg-orange-200 text-orange-800 font-semibold py-2 px-4
                      rounded-xl ml-2 shadow-md dark:bg-orange-800 dark:text-orange-100 dark:hover:bg-orange-700
                    ]
  end
end
