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

feature 'Order Index Page', type: %i[feature admin] do
  context 'with pagination checks' do
    before do
      User.destroy_all
      create_list :user, 125

      visit users_path
    end

    it 'displays 1..5 pages links and next/last buttons' do
      expect(page).to have_css('span', text: '1', class: 'bg-purple-500')

      (2..5).each do |i|
        expect(page).to have_link(i.to_s, href: users_path(page: i))
      end
    end

    it 'displays next/last buttons' do
      expect(page).to have_link('Next', href: users_path(page: 2))
      expect(page).to have_link('Last', href: users_path(page: 5))
    end

    include_examples 'Click on Page', '2'
    include_examples 'Click on Page', '3'
    include_examples 'Click on Page', '4'
    include_examples 'Click on Page', '5'
    include_examples 'Click on Page', '2', 'Next'
    include_examples 'Click on Page', '5', 'Last'
  end
end
