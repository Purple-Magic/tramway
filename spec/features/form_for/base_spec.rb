# frozen_string_literal: true

require 'rails_helper'

feature 'Form For Base Test', :js, type: :feature do
  shared_examples 'form for classes' do |expected_classes|
    scenario 'check text_field' do
      expect(page).to have_selector(
        "input.#{class_selector(expected_classes.fetch(:text_input))}"
      )
    end

    scenario 'check file_field' do
      expect(page).to have_selector("input[type='file']", visible: false)
      expect(page).to have_selector(
        "label.#{class_selector(expected_classes.fetch(:file_button))}"
      )
    end

    scenario 'check select' do
      expect(page).to have_selector(
        "select.#{class_selector(expected_classes.fetch(:select))}"
      )
    end

    scenario 'check text_area' do
      expect(page).to have_selector(
        'textarea.tramway-form__textarea'
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
      expect(button[:class].split).to include(*expected_classes.fetch(:checkbox_input))
    end

    scenario 'keeps unchecked checkbox visible' do
      button = find("button[role='checkbox']")

      expect(button[:style]).to be_blank
      expect(button[:class].split).to include('tramway-form__check-input')
      expect(page).to have_selector("button[role='checkbox'] span.tramway-form__check-indicator[hidden]", visible: :all)
    end

    scenario 'toggle checkbox' do
      find("button[role='checkbox']").click

      expect(page).to have_selector(
        "button[role='checkbox'][aria-checked='true'][data-state='checked'].tramway-form__check-input"
      )
      expect(page).to have_selector("input[type='checkbox'][data-ui--checkbox-target='input']:checked", visible: false)
      expect(page).to have_selector("button[role='checkbox'] span.tramway-form__check-indicator:not([hidden]) svg")
    end
  end

  context 'with the default classes' do
    before { visit new_user_path }

    it_behaves_like 'form for classes',
                    text_input: %w[tramway-form__input],
                    file_button: %w[tramway-form__file-button],
                    select: %w[tramway-form__select],
                    checkbox_input: %w[tramway-form__check-input]
  end
end
