# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Chats::Messages::TableComponent, type: :component do
  it 'wraps the table in a styled container' do
    data = [
      %w[Name Value],
      %w[Latency 42ms]
    ]

    render_inline(described_class.new(data:))

    expect(page).to have_css(
      ".#{class_selector(%w[
        mt-3
        overflow-hidden
        rounded-xl
        border
        border-gray-200
        bg-white
        shadow-sm
        dark:border-gray-700
        dark:bg-gray-900
      ])}"
    )
  end
end
