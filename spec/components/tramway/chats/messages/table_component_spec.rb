# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Chats::Messages::TableComponent, type: :component do
  it 'wraps the table in a styled container' do
    data = [
      %w[Name Value],
      %w[Latency 42ms]
    ]

    render_inline(described_class.new(data:))

    expect(page).to have_css('.tramway-chat__table')
  end
end
