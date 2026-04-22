# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Table::HeaderComponent, type: :component do
  it 'uses headers argument to set grid columns' do
    render_inline(described_class.new(headers: %w[Name Email])) do
      '<div class="div-table-cell">Ignored</div>'.html_safe
    end

    expect(page).to have_css('.div-table-row.md\:grid-cols-2', text: 'Name')
    expect(page).to have_css('.div-table-row.md\:grid-cols-2', text: 'Email')
    expect(page).not_to have_text('Ignored')
  end

  it 'counts cells from content when headers are not provided' do
    render_inline(described_class.new) do
      <<~HTML.html_safe
        <div class="div-table-cell">Name</div>
        <div class="div-table-cell hidden">Email</div>
      HTML
    end

    expect(page).to have_css('.div-table-row.md\:grid-cols-2')
    expect(page).to have_css('.div-table-cell.hidden', text: 'Email')
  end
end
