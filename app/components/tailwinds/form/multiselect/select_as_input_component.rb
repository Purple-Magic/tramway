# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      class SelectAsInputComponent < ViewComponent::Base
        extend Dry::Initializer[undefined: false]

        option :options
        option :attribute
        option :input
      end
    end
  end
end
