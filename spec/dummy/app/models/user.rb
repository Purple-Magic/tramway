# frozen_string_literal: true

# Test model
class User < ApplicationRecord
  has_many :posts

  attr_reader :password, :file
  # :reek:Attribute { enabled: false }
  attr_accessor :permissions
end
