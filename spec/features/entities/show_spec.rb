# frozen_string_literal: true

require 'rails_helper'

feature 'Entities Show Page', :js, type: :feature do
  before { Post.destroy_all }

  let(:user) { create :user, email: 'show@example.com' }
  let!(:post) { create :post, aasm_state: :published, title: 'Displayed Post', user: }

  scenario 'renders configured show attributes' do
    visit "/admin/posts/#{post.id}"

    within '.div-table' do
      expect(page).to have_selector('.div-table-row', count: 2)
      expect(page).to have_selector('.div-table-cell', text: 'Title')
      expect(page).to have_selector('.div-table-cell', text: 'Displayed Post')
      expect(page).to have_selector('.div-table-cell', text: 'User email')
      expect(page).to have_selector('.div-table-cell', text: user.email)
    end
  end
end
