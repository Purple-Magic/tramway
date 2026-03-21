# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Table::RowComponent, type: :component do
  let(:row_content) do
    <<~HTML.html_safe
      <div class="div-table-cell">Name</div>
      <div class="div-table-cell hidden">Email</div>
    HTML
  end

  it 'does not render preview panel when preview is false' do
    render_inline(described_class.new(preview: false)) { row_content }

    expect(page).to have_css('.div-table-row', text: 'Name')
    expect(page).to have_css('.div-table-row', text: 'Email')
    expect(page).not_to have_css('#roll-up')
  end
end
