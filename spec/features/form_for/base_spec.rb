# frozen_string_literal: true

require 'rails_helper'
feature 'Form For Base Test', :js, type: :feature do
  shared_examples 'form for theme classes' do |theme_classes|
    scenario 'check text_field' do
      expect(page).to have_selector(
        "input.text-base.px-3.py-2.#{class_selector(theme_classes.fetch(:text_input))}"
      )
    end

    scenario 'check file_field' do
      expect(page).to have_selector("input[type='file']", visible: false)
      expect(page).to have_selector(
        "label.inline-block.text-base.px-4.py-2.#{class_selector(theme_classes.fetch(:file_button))}"
      )
    end

    scenario 'check select' do
      expect(page).to have_selector(
        "select.text-base.px-3.py-2.#{class_selector(theme_classes.fetch(:select))}"
      )
    end

    scenario 'check text_area' do
      expect(page).to have_selector(
        "textarea.text-base.px-3.py-2.#{class_selector(theme_classes.fetch(:text_input))}"
      )
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    before { visit new_user_path }

    it_behaves_like 'form for theme classes',
                    text_input: %w[
                      w-full rounded-xl border border-gray-700 bg-gray-900 text-gray-100 shadow-inner
                      focus:outline-none focus:ring-2 focus:ring-gray-600 placeholder-gray-500
                    ],
                    file_button: %w[
                      inline-block text-blue-100 font-semibold rounded-xl cursor-pointer mt-4 bg-blue-900
                      hover:bg-blue-800 shadow-md
                    ],
                    select: %w[
                      w-full rounded-xl border border-gray-700 bg-gray-900 text-gray-100 shadow-inner
                      focus:outline-none focus:ring-2 focus:ring-gray-600 disabled:cursor-not-allowed
                      disabled:bg-gray-800 disabled:text-gray-500
                    ]
  end
end
