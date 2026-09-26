# frozen_string_literal: true

require 'rails_helper'

describe Tramway::TableComponent, type: :component do
  it 'renders the table shell with the base background' do
    render_inline(described_class.new) do
      'Table content'
    end

    expect(page).to have_css('.div-table.bg-zinc-950.w-full.overflow-x-scroll.tramway-scrollbar', text: 'Table content')
  end

  it 'merges custom table classes with the base background' do
    render_inline(described_class.new(options: { class: '!bg-red' })) do
      'Table content'
    end

    expect(page).to have_css("div.div-table.bg-zinc-950.w-full[class*='!bg-red']", text: 'Table content')
  end
end
