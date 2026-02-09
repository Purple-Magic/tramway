# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ChatComponent, type: :component do
  # rubocop:disable RSpec/ExampleLength
  it 'renders common chat container styles' do
    chat_id = 123

    allow(view_context).to receive(:turbo_stream_from).and_return('')

    render_inline(described_class.new(chat_id:, messages: [], send_message_path: '/messages'))

    expect(page).to have_css(
      "#chat.#{class_selector(%w[
                                mx-auto
                                flex
                                flex-col
                                mt-6
                                max-h-full
                                w-full
                                rounded-2xl
                                border
                                border-gray-200
                                bg-white
                                shadow-sm
                                dark:border-gray-700
                                dark:bg-gray-900
                                h-[650px]
                              ])}"
    )
    expect(page).to have_css(
      "#messages.#{class_selector(%w[
                                    flex-1
                                    overflow-y-auto
                                    bg-gray-50
                                    p-6
                                    space-y-4
                                    dark:bg-gray-800/60
                                    text-gray-900
                                    dark:text-gray-100
                                  ])}"
    )
  end
  # rubocop:enable RSpec/ExampleLength
end
