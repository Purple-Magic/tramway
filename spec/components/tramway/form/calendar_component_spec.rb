# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Form::CalendarComponent, type: :component do
  around do |example|
    with_request_url('/users?status=active&filters%5Brole%5D=admin&month=4&year=2024') { example.run }
  end

  it 'renders month and year selectors with preserved query fields' do
    render_inline(described_class.new)

    expect(page).to have_css("form[action='/users'][method='get']")
    expect(page).to have_select('Month', selected: 'April')
    expect(page).to have_select('Year', selected: '2024')
    expect(page).to have_css("input[type='hidden'][name='status'][value='active']", visible: :hidden)
    expect(page).to have_css("input[type='hidden'][name='filters[role]'][value='admin']", visible: :hidden)
    expect(page).not_to have_css("input[type='hidden'][name='month']", visible: :hidden)
    expect(page).not_to have_css("input[type='hidden'][name='year']", visible: :hidden)
  end

  it 'renders the calendar with current component colors' do
    render_inline(described_class.new(month: 4, year: 2024, selected_dates: [DateTime.new(2024, 4, 15, 12)]))

    expect(page).to have_css("[aria-label='Calendar'].border-zinc-800.bg-zinc-950")
    expect(page).to have_css('.div-table-row.md\\:grid-cols-7', text: 'Sun')
    expect(page).to have_css('.rounded-md.bg-zinc-50.text-zinc-950', text: '15')
    expect(page).to have_css('.text-zinc-500', text: '31')
  end

  it 'renders date action forms with the selected date param' do
    render_inline(
      described_class.new(
        month: 4,
        year: 2024,
        action: {
          path: '/projects',
          method: :post,
          params: { project: { name: 'Roadmap' } }
        }
      )
    )

    expect(page).to have_css("form[action='/projects'][method='post']")
    expect(page).to have_button('15')
    expect(page).to have_css("input[type='hidden'][name='project[name]'][value='Roadmap']", visible: :hidden)
    expect(page).to have_css("input[type='hidden'][name='project[date]'][value='2024-04-15']", visible: :hidden)
  end
end
