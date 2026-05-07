# frozen_string_literal: true

require 'rails_helper'

describe Tramway::BackButtonComponent, type: :component do
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
                      inline-flex h-9 items-center justify-center rounded-md border border-zinc-800 bg-zinc-950 px-4
                      py-2 text-sm font-medium text-zinc-200 shadow-sm transition-colors hover:bg-zinc-800
                      focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300 ml-2
                    ]
  end
end
