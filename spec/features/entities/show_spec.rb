# frozen_string_literal: true

require 'rails_helper'

feature 'Entities Show Page', :js, type: :feature do
  before do
    Comment.destroy_all
    Post.destroy_all
  end

  let(:user) { create :user, email: 'show@example.com' }
  let!(:post) { create :post, aasm_state: :published, title: 'Displayed Post', user: }

  scenario 'renders configured show attributes' do
    visit "/admin/posts/#{post.id}"

    within '.div-table' do
      expect(page).to have_selector('.div-table-row', count: 3), page.text

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

    expect(page).to have_content('Show header for Displayed Post')
  end

  context 'with show associations' do
    let!(:original_per_page) { Kaminari.config.default_per_page }
    let(:tables) { all('.div-table') }

    before do
      Kaminari.configure { |config| config.default_per_page = 2 }

      create_list(:comment, 3, post:, user:, text: 'Comment text')

      visit "/admin/posts/#{post.id}"
    end

    after do
      Kaminari.configure { |config| config.default_per_page = original_per_page }
    end

    scenario 'renders show association headers' do
      within tables.last do
        within('.div-table-row[aria-label="Table Header"]') do
          expect(page).to have_selector('.div-table-cell', text: 'Text')
          expect(page).to have_selector('.div-table-cell', text: 'User email')
        end
      end
    end

    scenario 'renders show associations' do
      expect(tables.size).to eq(2), page.text

      within tables.last do
        expect(page).to have_selector('.div-table-row', count: 3)

        within all('.div-table-row')[1] do
          expect(page).to have_content('Comment text')
          expect(page).to have_content(user.email)
        end
      end
    end

    scenario 'renders show association pagination' do
      paginations = all('nav.pagination')
      expect(paginations.size).to eq(2)
    end
  end
end
