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
        "label.inline-flex.text-base.px-4.py-2.#{class_selector(theme_classes.fetch(:file_button))}"
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

    scenario 'check checkbox' do
      expect(page).to have_selector(
        "input[type='checkbox'].hidden[data-ui--checkbox-target='input']",
        visible: false
      )
      expect(page).to have_selector(
        "button[type='button'][role='checkbox'][aria-checked='false'][data-state='unchecked']"
      )
      button = find("button[role='checkbox']")
      expect(button[:class].split).to include(*theme_classes.fetch(:checkbox_input))
    end

    scenario 'toggle checkbox' do
      find("button[role='checkbox']").click

      expect(page).to have_selector(
        "button[role='checkbox'][aria-checked='true'][data-state='checked'].bg-zinc-50.text-zinc-950"
      )
      expect(page).to have_selector("input[type='checkbox'][data-ui--checkbox-target='input']:checked", visible: false)
      expect(page).to have_selector("button[role='checkbox'] span:not(.hidden) svg.h-4.w-4")
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    before { visit new_user_path }

    it_behaves_like 'form for theme classes',
                    text_input: %w[
                      w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-50 shadow-sm
                      transition-colors placeholder:text-zinc-500 focus-visible:outline-none
                      focus-visible:ring-2 focus-visible:ring-zinc-300 focus-visible:ring-offset-2
                      focus-visible:ring-offset-zinc-950 disabled:cursor-not-allowed disabled:opacity-50
                    ],
                    file_button: %w[
                      inline-flex items-center justify-center rounded-md border border-zinc-800 bg-zinc-950
                      text-zinc-50 font-medium shadow-sm transition-colors hover:bg-zinc-900
                      focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300
                      focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950 disabled:pointer-events-none
                      disabled:opacity-50 cursor-pointer mt-4
                    ],
                    select: %w[
                      w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-50 shadow-sm
                      transition-colors appearance-none focus-visible:outline-none focus-visible:ring-2
                      focus-visible:ring-zinc-300 focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950
                      disabled:cursor-not-allowed disabled:opacity-50
                    ],
                    checkbox_input: %w[
                      peer h-4 w-4 shrink-0 rounded-sm border border-zinc-800 bg-zinc-950 text-zinc-50
                      ring-offset-zinc-950
                      focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300
                      focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50
                      data-[state=checked]:border-zinc-50 data-[state=checked]:bg-zinc-50
                      data-[state=checked]:text-zinc-950
                    ]
  end
end
