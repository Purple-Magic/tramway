feature 'Entities Index Page', :js, type: :feature do
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

  context 'mobile version' do
    before { Capybara.javascript_driver = :headless_chrome_mobile }
    after { Capybara.javascript_driver = :headless_chrome }

    scenario 'displays mobile-friendly rows and correctly populates preview on click' do
      visit '/admin/posts'

      rows = all('.div-table .div-table-row.md\\:hidden.mb-2')
      expect(rows.count).to eq(3)

      rows.each_with_index do |row, index|
        # Simulate a click to open the preview
        row.click

        # Parse the data-items JSON from the row
        data_items = JSON.parse(row[:'data-items'])

        # Check that the preview is displayed
        within '#roll-up' do
          # Verify the dynamically added title
          title_text = data_items.values.first # Extract the first value as the title
          expect(page).to have_selector('h3.text-xl.text-white', text: title_text)

          # Verify the table content
          data_items.each do |key, value|
            # Check key row
            expect(page).to have_selector('.div-table-row.bg-purple-300.text-purple-700', text: key)
            # Check value row
            expect(page).to have_selector('.div-table-row.dark\\:bg-gray-800', text: value)
          end
        end

        # Close the preview
        find("button[data-action='click->preview#close']").click

        # Ensure the preview is hidden after closing
        expect(page).not_to have_selector('#roll-up', visible: true)
      end
    end
  end
end
