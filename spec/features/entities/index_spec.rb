feature 'Entities Index Page', type: :feature do
  before { create_list :post, 3 }

  scenario 'successfully responds' do
    visit '/admin/posts'

    expect(page).to have_selector('h1', text: 'Posts'), page.html
  end

  scenario 'raises an error if entity is not found' do
    visit '/admin/users'

    expect(page).to have_http_status(:not_found)
  end
end
