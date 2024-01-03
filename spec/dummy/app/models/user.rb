# frozen_string_literal: true

# Test model
class User < ApplicationRecord
  attr_reader :password, :file, :role
end
