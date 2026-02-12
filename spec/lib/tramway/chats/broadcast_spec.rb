# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::Chats::Broadcast do
  subject(:message) { message_class.new }

  let(:message_class) do
    Class.new do
      include Tramway::Chats::Broadcast

      def chat
        OpenStruct.new(user: OpenStruct.new(id: 42))
      end

      def broadcast_append_to(*); end
    end
  end

  describe '#append_message' do
    it 'broadcasts a message for allowed type values' do
      allow(message).to receive(:broadcast_append_to)

      message.append_message(message_type: :sent, text: 'Hello', sent_at: Time.current)

      expect(message).to have_received(:broadcast_append_to).with(
        [42, 'messages'],
        target: 'messages',
        partial: 'tramway/chats/message',
        locals: hash_including(type: :sent, text: 'Hello', sent_at: kind_of(Time))
      )
    end

    it 'raises for unsupported message_type' do
      expect do
        message.append_message(message_type: :invalid, text: 'Hello', sent_at: Time.current)
      end.to raise_error(ArgumentError, 'message_type must be either :sent or :received')
    end
  end
end
