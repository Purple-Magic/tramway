# frozen_string_literal: true

require 'rails_helper'
require 'tramway/chats/broadcast'

RSpec.describe Tramway::Chats::Broadcast do
  describe '#tramway_chat_append_message' do
    context 'when broadcast_append_to is available on the instance' do
      subject(:broadcaster) { broadcaster_class.new }

      let(:broadcaster_class) do
        Class.new do
          include Tramway::Chats::Broadcast

          def broadcast_append_to(*)
            true
          end
        end
      end

      it 'uses instance broadcast_append_to with expected payload' do
        expect(broadcaster).to receive(:broadcast_append_to).with(
          ['chat-42', 'messages'],
          target: 'messages',
          partial: 'tramway/chats/message',
          locals: {
            type: :sent,
            text: 'Hello',
            sent_at: Time.zone.parse('2026-01-01 10:00:00')
          }
        )

        broadcaster.tramway_chat_append_message(
          chat_id: 'chat-42',
          message_type: :sent,
          text: 'Hello',
          sent_at: Time.zone.parse('2026-01-01 10:00:00')
        )
      end
    end

    context 'when broadcast_append_to is not available on the instance' do
      subject(:broadcaster) { broadcaster_class.new }

      let(:broadcaster_class) do
        Class.new do
          include Tramway::Chats::Broadcast
        end
      end

      it 'uses Turbo::StreamsChannel.broadcast_append_to with expected payload' do
        expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
          ['chat-42', 'messages'],
          target: 'messages',
          partial: 'tramway/chats/message',
          locals: {
            type: :received,
            text: 'Hi',
            sent_at: Time.zone.parse('2026-01-01 10:01:00')
          }
        )

        broadcaster.tramway_chat_append_message(
          chat_id: 'chat-42',
          message_type: :received,
          text: 'Hi',
          sent_at: Time.zone.parse('2026-01-01 10:01:00')
        )
      end
    end

    it 'raises when message_type is invalid' do
      broadcaster = Class.new do
        include Tramway::Chats::Broadcast
      end.new

      expect do
        broadcaster.tramway_chat_append_message(chat_id: 'chat-42', message_type: :invalid, text: 'Hello', sent_at: Time.current)
      end.to raise_error(ArgumentError, 'message_type must be :sent or :received')
    end
  end
end
