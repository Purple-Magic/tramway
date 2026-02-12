# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ChatComponent, type: :component do
  # rubocop:disable RSpec/ExampleLength
  it 'renders common chat container styles' do
    chat_id = 123

    allow_any_instance_of(ActionView::Base).to receive(:turbo_stream_from).and_return('')

    render_inline(described_class.new(chat_id:, messages: [], send_message_path: '/messages'))

    expect(page).to have_css(
      "#chat.#{class_selector(%w[
                                flex
                                flex-1
                                h-full
                                w-full
                                min-w-0
                                min-h-0
                                flex-col
                              ])}"
    )
    expect(page).to have_css(
      "#messages.#{class_selector(%w[
                                    flex
                                    flex-col-reverse
                                    flex-1
                                    min-h-0
                                    overflow-y-auto
                                    p-2
                                    md:p-6
                                    space-y-2
                                    space-y-reverse
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
