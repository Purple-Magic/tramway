# frozen_string_literal: true

module Tramway
  module Component
    # You can use this class as a base for all your components
    class Base < ViewComponent::Base
      extend Dry::Initializer[undefined: false]
    end
  end
end
