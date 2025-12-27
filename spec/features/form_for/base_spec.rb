# frozen_string_literal: true

require 'rails_helper'
feature 'Form For Base Test', :js, type: :feature do
  before do
    visit new_user_path
  end

  scenario 'check text_field' do
    expect(page).to have_selector('input.text-base.px-3.py-2.w-full.border.rounded.focus\\:outline-none.bg-gray-800.border-gray-600.text-white.focus\\:border-red-400.placeholder-white') # rubocop:disable Layout/LineLength
  end

  scenario 'check file_field' do
    expect(page).to have_selector("input[type='file']", visible: false)
    expect(page).to have_selector('label.inline-block.font-bold.py-2.px-4.rounded.cursor-pointer.mt-4')
  end

  scenario 'check select' do
    expect(page).to have_selector('select.border.rounded.focus\\:outline-none.focus\\:ring-2.focus\\:border-transparent.py-2.px-3') # rubocop:disable Layout/LineLength
  end

  scenario 'check text_area' do
    expect(page).to have_selector('textarea.text-base.px-3.py-2.w-full.border.rounded.focus\\:outline-none.bg-gray-800.border-gray-600.text-white.focus\\:border-red-400.placeholder-white') # rubocop:disable Layout/LineLength
  end
end
