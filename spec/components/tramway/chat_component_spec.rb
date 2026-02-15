# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ChatComponent, type: :component do
  let(:chat_id) { 123 }
  let(:messages) { [] }
  let(:message_form) { nil }
  let(:options) { {} }
  let(:send_messages_enabled) { true }

  subject(:rendered_component) do
    render_inline(
      described_class.new(
        chat_id:,
        messages:,
        message_form:,
        options:,
        send_message_path: '/messages',
        send_messages_enabled:
      )
    )
  end

  before do
    without_partial_double_verification do
      allow_any_instance_of(described_class).to receive(:inline_svg)
        .and_return('<svg class="w-8 h-8 text-gray-500 mx-auto my-4"></svg>'.html_safe)
    end
  end

  # rubocop:disable RSpec/ExampleLength
  it 'renders common chat container styles' do
    rendered_component

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
                                    flex-col
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

  context 'when messages are provided' do
    let(:messages) do
      [
        { id: 1, type: :sent, text: 'Hello there' },
        { id: 2, type: :received, text: 'Hi!' }
      ]
    end

    it 'renders each message via message component' do
      rendered_component

      expect(page).to have_css('.items-end', text: 'Hello there')
      expect(page).to have_css('.items-start', text: 'Hi!')
    end
  end

  context 'when chat is disabled' do
    let(:options) { { disabled: true } }

    it 'renders waiting dots icon' do
      rendered_component

      expect(page).to have_css('svg.w-8.h-8.text-gray-500.mx-auto.my-4')
    end
  end

  context 'when message form is provided' do
    let(:message_form_class) do
      Class.new do
        include ActiveModel::Model

        attr_accessor :text, :chat_id, :conversation_id
      end
    end
    let(:message_form) { message_form_class.new }
    let(:options) { { conversation_id: 777 } }

    it 'renders form fields and hidden values' do
      rendered_component

      expect(page).to have_css("form[action='/messages'][method='post']")
      expect(page).to have_field('message[text]', disabled: false)
      expect(page).to have_field('message[chat_id]', type: 'hidden', with: chat_id.to_s)
      expect(page).to have_field('message[conversation_id]', type: 'hidden', with: '777')
      expect(page).to have_button('🡩')
    end

    context 'when message sending is disabled' do
      let(:send_messages_enabled) { false }

      it 'renders disabled text input with waiting placeholder' do
        rendered_component

        expect(page).to have_field(
          'message[text]',
          disabled: true,
          placeholder: I18n.t('tramway.chat.placeholders.waiting')
        )
      end
    end
  end
end
