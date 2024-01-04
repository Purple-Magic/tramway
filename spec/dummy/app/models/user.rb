# frozen_string_literal: true

# Test model
class User < ApplicationRecord
  has_many :posts

  attr_reader :password, :file, :role
end
