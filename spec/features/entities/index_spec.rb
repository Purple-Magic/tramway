feature 'Entities Index Page', type: :feature do
  before { create_list :post, 3 }

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

  scenario 'raises an error if entity is not found' do
    visit '/admin/users'

    expect(page).to have_http_status(:not_found)
  end

  scenario 'displays the div-table with appropriate structure and content' do
    visit '/admin/posts'

    expect(page).to have_selector('.div-table', text: '', visible: true)

    within '.div-table' do
      expect(page).to have_selector('.div-table-row.hidden.md\\:grid.dark\\:text-gray-400', count: 1)
      within first('.div-table-row.hidden.md\\:grid') do
        expect(page).to have_selector('.div-table-cell', text: 'Title')
        expect(page).to have_selector('.div-table-cell', text: 'User')
      end
    end
  end

  scenario 'displays rows of the table with correct data' do
    visit '/admin/posts'

    within '.div-table' do
      expect(page).to have_selector('.div-table-row.hidden.md\\:grid', minimum: 1)
    end
  end

  scenario 'displays mobile-friendly rows' do
    visit '/admin/posts'

    within '.div-table' do
      expect(page).to have_selector('.div-table-row.md\\:hidden.mb-2', count: 3)
    end
  end
end
