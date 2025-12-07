# frozen_string_literal: true

require 'rails_helper'

feature 'Entities Create Page', :js, type: :feature do
  before do
    Post.destroy_all

    create :user
  end

  context 'with index page checks' do
    scenario 'displays new button' do
      visit '/admin/posts'

      expect(page).to have_button('New')
    end
  end

  context 'with new form checks' do
    scenario 'displays form fields' do
      visit '/admin/posts'

      click_button 'New'

      expect(page).to have_content('Create Post')
      expect(page).to have_field('post[title]')
      expect(page).to have_field('post[text]')
      expect(page).to have_field('post[user_id]', type: :hidden, with: User.first.id)
    end
  end

  context 'with creating checks' do
    before do
      visit '/admin/posts'

      click_button 'New'

      fill_in 'post[title]', with: 'Test Post'
      fill_in 'post[text]', with: 'This is a test post.'

      click_button 'Save'
    end

    scenario 'creates new record' do
      expect(page).to have_content('The record is created')
      expect(page).to have_content('Test Post')
      expect(page).to have_content('This is a test post.')
    end

    scenario 'creates new record with needed data' do
      sleep 2 # wait for DB transaction to complete

      post = Post.last

      expect(post.title).to eq('Test Post')
      expect(post.text).to eq('This is a test post.')
      expect(post.user).to eq(User.first)
    end
  end
end
