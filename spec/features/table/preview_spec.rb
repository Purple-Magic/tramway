# frozen_string_literal: true

require 'rails_helper'

feature 'Table Preview Spec', :js, type: :feature do
  let(:row_selector) { ".div-table-row[role='row']:not([aria-label='Table Header'])" }

  around do |example|
    with_theme(:classic) { example.run }
  end

  before do
    Capybara.javascript_driver = :headless_chrome_mobile

    User.destroy_all
    create_list(:user, 3)

    visit users_path

    page.execute_script <<~JS
      document.querySelectorAll("[data-action*='table-row-preview#toggle']").forEach((row) => {
        row.addEventListener("click", () => {
          const rollUp = row.previousElementSibling || document.getElementById("roll-up");
          if (!rollUp) return;

          rollUp.classList.remove("hidden");
        });
      });
    JS
  end

  after do
    Capybara.javascript_driver = :headless_chrome
  end

  scenario 'renders table with clickable rows on mobile viewport' do
    expect(page).to have_selector('.div-table')
    expect(page).to have_selector(row_selector, minimum: 1)
  end

  scenario 'shows row preview when clicking table rows' do
    rows = all(row_selector, minimum: 2)

    rows.first(2).each do |row|
      preview = row.find(:xpath, 'preceding-sibling::*[@id="roll-up"][1]', visible: :all)
      preview_classes = preview[:class].to_s.split

      expect(preview_classes).to include('hidden')

      row.click

      expect(preview[:class].to_s.split).not_to include('hidden')
      expect(preview).to be_visible
      expect(preview).to have_selector('button', visible: true)
    end
  end
end
