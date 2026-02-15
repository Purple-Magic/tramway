# frozen_string_literal: true

require 'rails_helper'
require 'tramway/chats/broadcast'

RSpec.describe Tramway::Chats::Broadcast do
  describe '#tramway_chat_append_message' do
    let(:broadcaster) do
      Class.new do
        include Tramway::Chats::Broadcast
      end.new
    end
    let(:common_args) do
      {
        chat_id: 'chat-42',
        text: 'Hello'
      }
    end

    before do
      stub_const('Turbo::StreamsChannel', Class.new)
    end

    let(:streams_channel) { class_double('Turbo::StreamsChannel').as_stubbed_const }

    it 'broadcasts sent messages to the chat stream' do
      expect(streams_channel).to receive(:broadcast_append_to).with(
        %w[chat-42 messages],
        target: 'messages',
        partial: 'tramway/chats/message',
        locals: {
          type: :sent,
          text: 'Hello',
          sent_at: Time.zone.parse('2026-01-01 10:00:00')
        }
      )

      broadcaster.tramway_chat_append_message(
        type: :sent,
        sent_at: Time.zone.parse('2026-01-01 10:00:00'),
        **common_args
      )
    end

    it 'broadcasts received messages when type is passed as a string' do
      expect(streams_channel).to receive(:broadcast_append_to).with(
        %w[chat-42 messages],
        target: 'messages',
        partial: 'tramway/chats/message',
        locals: {
          type: 'received',
          text: 'Hello',
          sent_at: Time.zone.parse('2026-01-01 10:01:00')
        }
      )

      broadcaster.tramway_chat_append_message(
        type: 'received',
        sent_at: Time.zone.parse('2026-01-01 10:01:00'),
        **common_args
      )
    end

    it 'raises when type is invalid' do
      expect do
        broadcaster.tramway_chat_append_message(chat_id: 'chat-42', type: :invalid, text: 'Hello',
                                                sent_at: Time.current)
      end.to raise_error(ArgumentError, 'message_type must be :sent or :received')
    end
  end
end
