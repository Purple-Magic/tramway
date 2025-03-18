# frozen_string_literal: true

feature 'Form For Base Test', :js, type: :feature do
  before do
    visit new_user_path
  end

  scenario 'check text_field' do
    expect(page).to have_selector("input.w-full.bg-white.px-3.py-2.border.border-gray-300.rounded.focus\\:outline-none.focus\\:border-red-500.dark\\:placeholder-gray-400")
  end

  scenario 'check file_field' do
    expect(page).to have_selector("input[type='file']", visible: false)
    expect(page).to have_selector('label.inline-block.bg-blue-500.hover\\:bg-blue-700.text-white.font-bold.py-2.px-4.rounded.cursor-pointer.mt-4')
  end

  scenario 'check select' do
    expect(page).to have_selector('select.bg-white.border.border-gray-300.text-gray-700.rounded.focus\\:outline-none.focus\\:ring-2.focus\\:ring-blue-500.focus\\:border-transparent.py-2.px-3')
  end

  scenario 'check text_area' do
    expect(page).to have_selector('textarea.w-full.bg-white.px-3.py-2.border.border-gray-300.rounded.focus\\:outline-none.focus\\:border-red-500.dark\\:placeholder-gray-400')
  end
end
