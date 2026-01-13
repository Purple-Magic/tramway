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
                      w-full border rounded focus:outline-none bg-gray-800 border-gray-600 text-white
                      focus:border-red-400 placeholder-white
                    ],
                    file_button: %w[
                      font-bold rounded cursor-pointer mt-4 bg-blue-600 hover:bg-blue-500 text-white
                    ],
                    select: %w[
                      w-full border rounded focus:outline-none focus:ring-2 focus:border-transparent
                      disabled:cursor-not-allowed bg-gray-800 border-gray-600 text-gray-100 focus:ring-red-400
                      disabled:bg-gray-800 disabled:text-gray-500
                    ]
  end

  context 'with neomorphism theme' do
    around { |example| with_theme(:neomorphism) { example.run } }

    before { visit new_user_path }

    it_behaves_like 'form for theme classes',
                    text_input: %w[
                      w-full rounded-xl border border-gray-200 bg-gray-100 text-gray-700 shadow-inner
                      focus:outline-none focus:ring-2 focus:ring-gray-300 placeholder-gray-400 dark:bg-gray-900
                      dark:border-gray-700 dark:text-gray-100 dark:placeholder-gray-500 dark:focus:ring-gray-600
                    ],
                    file_button: %w[
                      font-semibold rounded-xl cursor-pointer mt-4 bg-blue-100 hover:bg-blue-200 text-blue-800
                      shadow-md dark:bg-blue-900 dark:text-blue-100 dark:hover:bg-blue-800
                    ],
                    select: %w[
                      w-full rounded-xl border border-gray-200 bg-gray-100 text-gray-700 shadow-inner
                      focus:outline-none focus:ring-2 focus:ring-gray-300 disabled:cursor-not-allowed
                      disabled:bg-gray-200 disabled:text-gray-400 dark:bg-gray-900 dark:border-gray-700
                      dark:text-gray-100 dark:focus:ring-gray-600 dark:disabled:bg-gray-800
                      dark:disabled:text-gray-500
                    ]
  end
end
