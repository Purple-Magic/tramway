# frozen_string_literal: true

require 'rails_helper'

feature 'Form For Base Test', :js, type: :feature do
  shared_examples 'form for theme classes' do |theme_classes|
    scenario 'check text_field' do
      expect(page).to have_selector(
        "input.h-9.text-sm.px-3.py-1.#{class_selector(theme_classes.fetch(:text_input))}"
      )
    end

    scenario 'check file_field' do
      expect(page).to have_selector("input[type='file']", visible: false)
      expect(page).to have_selector(
        "label.inline-flex.h-9.text-sm.px-4.py-2.#{class_selector(theme_classes.fetch(:file_button))}"
      )
    end

    scenario 'check select' do
      expect(page).to have_selector(
        "select.h-9.text-sm.px-3.py-1.#{class_selector(theme_classes.fetch(:select))}"
      )
    end

    scenario 'check text_area' do
      expect(page).to have_selector(
        "textarea.h-9.text-sm.px-3.py-1.#{class_selector(theme_classes.fetch(:text_area))}"
      )
    end

    scenario 'check checkbox' do
      expect(page).to have_selector(
        "input[type='checkbox'].#{class_selector(theme_classes.fetch(:checkbox_input))}",
        visible: :all
      )
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    before { visit new_user_path }

    it_behaves_like 'form for theme classes',
                    text_input: %w[
                      w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm
                      placeholder:text-zinc-500 focus-visible:outline-none focus-visible:ring-1
                      focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50
                    ],
                    text_area: %w[
                      min-h-20 w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm
                      placeholder:text-zinc-500 focus-visible:outline-none focus-visible:ring-1
                      focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50
                    ],
                    file_button: %w[
                      items-center justify-center rounded-md bg-zinc-50 font-medium text-zinc-950 shadow-sm
                      transition-colors hover:bg-zinc-200 cursor-pointer mt-4
                    ],
                    select: %w[
                      w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm
                      focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300
                      disabled:cursor-not-allowed disabled:opacity-50
                    ],
                    checkbox_input: %w[
                      absolute size-px overflow-hidden whitespace-nowrap border-0 p-0 -m-px [clip-path:inset(50%)]
                    ]
  end
end
