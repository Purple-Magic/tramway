# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ChatComponent, type: :component do
  # rubocop:disable RSpec/ExampleLength
  it 'renders common chat container styles' do
    chat_id = 123

    helpers.define_singleton_method(:turbo_stream_from) { '' }

    render_inline(described_class.new(chat_id:, messages: [], send_message_path: '/messages'))

    expect(page).to have_css(
      "#chat.#{class_selector(%w[
                                mx-auto
                                flex
                                flex-1
                                flex-col
                                w-full
                                rounded-2xl
                                border
                                shadow-sm
                                ring-gray-700
                                md:p-4
                                border-gray-100
                                min-h-0
                                overflow-hidden
                              ])}"
    )
    expect(page).to have_css(
      "#messages.#{class_selector(%w[
                                    flex-1
                                    min-h-0
                                    overflow-y-auto
                                    p-2
                                    md:p-6
                                    space-y-2
                                    md:space-y-4
                                    md:rounded-xl
                                    rounded-t-xl
                                    text-gray-100
                                    bg-gray-800/60
                                  ])}"
    )
  end
  # rubocop:enable RSpec/ExampleLength
end
