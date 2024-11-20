# frozen_string_literal: true

module Tramway
  module Component
    class Base < ViewComponent::Base
      extend Dry::Initializer[undefined: false]
    end
  end
end
