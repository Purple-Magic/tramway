# frozen_string_literal: true

module Tramway
  module Chats
    class MessageComponent < Tramway::BaseComponent
      option :type
      option :text, optional: true, default: -> { '' }
      option :data, optional: true, default: -> { {} }
      option :sent_at, optional: true, default: -> { nil }
      option :options, optional: true, default: -> { {} }

      def data_view
        if data.nil?
          nil
        elsif array2D?(data)
          :table
        end
      end

      def text_color
        if pending?
          'text-gray-400 dark:text-gray-600'
        else
          'text-black dark:text-white'
        end
      end

      private

      def array2D?(array)
        array.is_a?(Array) && array.all? do |inner|
          inner.is_a?(Array) && inner.none? { |e| e.is_a?(Array) }
        end
      end

      def on_the_left?
        type.to_sym == :received
      end

      def on_the_right?
        type.to_sym == :sent
      end

      def show_sent_at?
        sent_at.present?
      end

      def pending?
        options[:pending]
      end

      def failed?
        options[:failed]
      end
    end
  end
end
