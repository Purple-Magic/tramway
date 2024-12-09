# frozen_string_literal: true

shared_examples 'Click on Page' do |page_number, text = nil|
  it "navigates to the correct #{text || page_number} page link is clicked" do
    visit users_path

    within 'nav.pagination', match: :first do
      click_link text || page_number
    end

    expect(page).to have_current_path(users_path(page: page_number))
  end
end
