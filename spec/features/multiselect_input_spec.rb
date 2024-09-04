feature "MultiselectComponent", type: :feature, js: true do
  scenario "allows user to select multiple options" do
    visit new_user_path

    find('#user_role_multiselect').click

    find('.mx-2.leading-6', text: 'Admin').click

    click_on 'Create user'
  end
end
