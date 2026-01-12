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

      expect { click_button 'Destroy' }.to change(Post, :count).by(-1)

      expect(page).to have_content('The record is deleted')
      expect(page).to have_current_path('/admin/posts')
    end
  end
end
