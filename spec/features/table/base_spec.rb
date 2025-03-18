# frozen_string_literal: true

feature 'Table Base Spec', :js, type: :feature do
  before do
    create_list(:user, rand(1..10))

    visit users_path
  end

  scenario 'check table' do
    expect(page).to have_selector('.div-table.w-full.text-left.rtl\\:text-right.text-gray-500.dark\\:text-gray-400.mt-4') # rubocop:disable Layout/LineLength
  end

  scenario 'check rows' do
    selector = [
      'div-table-row', 'grid', 'gap-4', 'bg-white', 'border-b', 'last\\:border-b-0', 'dark\\:bg-gray-800',
      'dark\\:border-gray-700', 'grid-cols-1'
    ].join('.')

    expect(page).to have_selector(".#{selector}", count: User.count)
  end

  scenario 'check cells' do
    expect(page).to have_selector(
      '.div-table-cell.px-6.py-4.font-medium.text-gray-900.whitespace-nowrap.dark\\:text-white.text-xs.sm\\:text-base',
      count: User.count
    )
  end
end
