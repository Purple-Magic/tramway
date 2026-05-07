# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Chats::Messages::TableComponent, type: :component do
  # rubocop:disable RSpec/ExampleLength
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
                           rounded-lg
                           border
                           border-zinc-800
                           bg-zinc-950
                           shadow-sm
                         ])}"
    )
  end
  # rubocop:enable RSpec/ExampleLength
end
