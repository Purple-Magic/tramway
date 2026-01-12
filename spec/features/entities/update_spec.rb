# frozen_string_literal: true

require 'rails_helper'

feature 'Entities Update Page', :js, type: :feature do
  before do
    Post.destroy_all

    create :user
  end

  let!(:post) do
    create :post, title: 'Original Post', text: 'Original text', user: User.first, aasm_state: :published
  end

  context 'with index page checks' do
    scenario 'displays edit button' do
      visit '/admin/posts'

      expect(page).to have_button('Edit')
    end
  end

  context 'with edit form checks' do
    scenario 'displays form fields' do
      visit '/admin/posts'

      click_button 'Edit'

      expect(page).to have_content('Edit Post')
      expect(page).to have_field('post[title]', with: 'Original Post')
      expect(page).to have_field('post[text]', with: 'Original text')
      expect(page).to have_field('post[user_id]', type: :hidden, with: User.first.id)
    end
  end

  context 'with updating checks' do
    before do
      visit '/admin/posts'

      click_button 'Edit'

      fill_in 'post[title]', with: 'Updated Post'
      fill_in 'post[text]', with: 'Updated text.'

      click_button 'Save'
    end

    scenario 'updates record' do
      expect(page).to have_content('The record is updated')
      expect(page).to have_content('Updated Post')
      expect(page).to have_content('Updated text.')
    end

    scenario 'updates record with needed data' do
      expect(page).to have_content('The record is updated')

      post.reload

      expect(post.title).to eq('Updated Post')
      expect(post.text).to eq('Updated text.')
      expect(post.user).to eq(User.first)
    end
  end
end
