# frozen_string_literal: true

feature 'Entities Index Page', :js, type: :feature do
  before { Post.destroy_all }

  context 'with default setup' do
    scenario 'displays table header' do
      visit '/admin/posts'

      within '.div-table' do
        expect(page).to have_selector('.div-table-row', count: 1)

        within first('.div-table-row') do
          expect(page).to have_selector('.div-table-cell', text: 'Title')
          expect(page).to have_selector('.div-table-cell', text: 'User')
        end
      end
    end
  end

  context 'with several posts' do
    before do
      posts = create_list :post, 3
      posts.each do |post|
        create :comment, post:
      end
    end

    let(:row_selector) { '.div-table-row.grid[role="row"]:not([aria-label="Table Header"]' }

    scenario 'successfully responds' do
      visit '/admin/posts'

      expect(page).to have_selector('h1', text: 'Posts'), page.html
    end

    scenario 'shows info message about `list_attributes` method' do
      visit '/admin/comments'

      expect(page).to have_content(
        'You should fill class-level method `self.list_attributes` inside your CommentDecorator'
      )
    end

    scenario 'displays the div-table' do
      visit '/admin/posts'

      expect(page).to have_selector('.div-table', text: '', visible: true)
    end

    scenario 'displays rows of the table with correct data' do
      visit '/admin/posts'

      within '.div-table' do
        expect(page).not_to have_selector(row_selector)
      end
    end

    context 'without scope' do
      let(:article_count) { 3 }

      before do
        Article.destroy_all

        create_list :article, article_count
      end

      scenario 'displays exact number of rows' do
        visit '/admin/articles'

        within '.div-table' do
          expect(page).to have_selector(row_selector, count: article_count)
        end
      end
    end

    context 'with scope' do
      let(:posts_count) { 2 }

      before do
        Post.all.sample(2).each { _1.update! aasm_state: :published }
      end

      scenario 'displays exact number of rows' do
        visit '/admin/posts'

        within '.div-table' do
          expect(page).to have_selector(row_selector, count: posts_count)
        end
      end
    end
  end
end
