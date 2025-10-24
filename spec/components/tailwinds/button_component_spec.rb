# frozen_string_literal: true

describe Tailwinds::ButtonComponent, type: :component do
  it 'renders link button with defaults when text provided' do
    render_inline(described_class.new(path: '/projects', text: 'View projects'))

    expect(page).to have_css "a[href='/projects']", text: 'View projects'
    expect(page).to have_css 'a.btn.btn-primary.flex.flex-row'
    expect(page).to have_css 'a.py-2.px-4'
    expect(page).to have_css 'a.bg-blue-500.hover\:bg-blue-700.text-white'
    expect(page).to have_css 'a.dark\:bg-blue-600.dark\:hover\:bg-blue-800.dark\:text-gray-300'
    expect(page).to have_css 'a.px-1.h-fit'
  end

  it 'renders button_to when method is not get and appends custom options' do
    render_inline(
      described_class.new(
        path: '/projects/1',
        text: 'Delete',
        method: :delete,
        color: :red,
        size: :small,
        options: { class: 'extra-class', data: { turbo_confirm: 'Are you sure?' } }
      )
    )

    expect(page).to have_css "form[action='/projects/1'] button", text: 'Delete'
    expect(page).to have_css 'button.cursor-pointer'
    expect(page).to have_css 'button.bg-red-500.hover\:bg-red-700'
    expect(page).to have_css 'button.text-sm.py-1.px-1'
    expect(page).to have_css 'button.extra-class'
    expect(page).to have_css "form button[data-turbo-confirm='Are you sure?']"
  end

  it 'renders block content when text is not provided' do
    render_inline(described_class.new(path: '/projects')) do
      'Open'
    end

    expect(page).to have_css "a[href='/projects']", text: 'Open'
  end
end
