# frozen_string_literal: true

require 'rails_helper'

feature 'Entities Destroy Page', :js, type: :feature do
  before do
    Post.destroy_all

    create :user
  end

  let!(:post) { create :post, title: 'Disposable Post', user: User.first, aasm_state: :published }

  context 'with index page checks' do
    scenario 'displays destroy button' do
      visit '/admin/posts'

      expect(page).to have_button('Destroy')
    end
  end

  context 'with destroying checks' do
    scenario 'removes record' do
      visit "/admin/posts/#{post.id}"

      previous_count = Post.count

      click_button 'Destroy'

      expect(page).to have_current_path('/admin/posts')

      expect(Post.count).to eq(previous_count - 1)
      expect(page).to have_content('The record is deleted')
    end
  end
end
