# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
    view.define_singleton_method(:turbo_stream_from) { '' }
  end

  describe '#tramway_chat' do
    let(:messages) do
      [
        { id: 1, type: :sent, text: 'Hello there' },
        { id: 2, type: :received, text: 'Hi!' }
      ]
    end

    it 'renders the chat component with message components' do
      html = view.tramway_chat(
        chat_id: 'chat-1',
        messages:,
        message_form: nil,
        send_message_path: '/messages'
      )

      fragment = Capybara::Node::Simple.new(html)

      expect(fragment).to have_css('#chat')
      expect(fragment).to have_css('.items-end', text: 'Hello there')
      expect(fragment).to have_css('.items-start', text: 'Hi!')
    end

    it 'raises when messages are missing id or type' do
      expect do
        view.tramway_chat(
          chat_id: 'chat-1',
          messages: [{ type: :sent, text: 'Hello' }],
          message_form: nil,
          send_message_path: '/messages'
        )
      end.to raise_error(ArgumentError, 'Each message must have :id and :type keys')
    end

    it 'raises when message type is invalid' do
      expect do
        view.tramway_chat(
          chat_id: 'chat-1',
          messages: [{ id: 1, type: :unknown, text: 'Hello' }],
          message_form: nil,
          send_message_path: '/messages'
        )
      end.to raise_error(ArgumentError, 'Message :type must be either :sent or :received')
    end
  end
end
