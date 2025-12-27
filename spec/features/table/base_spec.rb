# frozen_string_literal: true

require 'rails_helper'
feature 'Table Base Spec', :js, type: :feature do
  before do
    User.destroy_all

    create_list(:user, rand(1..10))

    visit users_path
  end

  scenario 'check table' do
    expect(page).to have_selector('.div-table.text-left.rtl\\:text-right.text-gray-400.w-full')
  end

  scenario 'check rows' do
    selector = [
      'div-table-row', 'grid', 'gap-4', 'border-b', 'last\\:border-b-0', 'bg-gray-800', 'border-gray-700', 'grid-cols-1'
    ].join('.')

    expect(page).to have_selector(".#{selector}", count: User.count)
  end

  scenario 'check cells' do
    selector = %w[
      div-table-cell px-6 py-4 font-medium text-white text-base
    ].join('.')

    expect(page).to have_selector(".#{selector}", count: User.count)
  end
end
