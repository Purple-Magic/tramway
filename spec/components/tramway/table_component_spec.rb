# frozen_string_literal: true

require 'rails_helper'

describe Tramway::TableComponent, type: :component do
  it 'renders the table shell with the data table primitive' do
    render_inline(described_class.new) do
      'Table content'
    end

    expect(page).to have_css('.div-table.tramway-data-table.w-full.tramway-scrollbar', text: 'Table content')
  end

  it 'merges custom table classes with the data table primitive' do
    render_inline(described_class.new(options: { class: '!bg-red' })) do
      'Table content'
    end

    expect(page).to have_css("div.div-table.tramway-data-table.w-full[class*='!bg-red']", text: 'Table content')
  end
end
