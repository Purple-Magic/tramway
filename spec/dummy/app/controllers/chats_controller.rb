# frozen_string_literal: true

class ChatsController < ApplicationController
  def show
    @messages = [
      { id: 1, type: :sent, text: 'Sent from feature spec' },
      { id: 2, type: :received, text: 'Received in feature spec' }
    ]
  end
end
