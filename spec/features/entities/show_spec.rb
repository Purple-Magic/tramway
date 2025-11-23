# frozen_string_literal: true

require 'rails_helper'

feature 'Entities Show Page', :js, type: :feature do
  before { Post.destroy_all }

  let(:user) { create :user, email: 'show@example.com' }
  let!(:post) { create :post, aasm_state: :published, title: 'Displayed Post', user: }

  scenario 'renders configured show attributes' do
    visit "/admin/posts/#{post.id}"

    within '.div-table' do
      expect(page).to have_selector('.div-table-row', count: 3)

      rows = [['Title', 'Displayed Post'], ['Aasm state', 'published'], ['User email', user.email]]
      rows.each_with_index do |(label, value), index|
        within all('.div-table-row')[index] do
          expect(page).to have_selector('.div-table-cell', text: label)
          expect(page).to have_selector('.div-table-cell', text: value)
        end
      end
    end
  end

  scenario 'renders configured show header content' do
    visit "/admin/posts/#{post.id}"

    within '.container' do
      expect(page).to have_content('Show header for Displayed Post')
    end
  end
end
