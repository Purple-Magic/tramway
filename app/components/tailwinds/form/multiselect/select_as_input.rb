# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Renders input as select
      class SelectAsInput < ViewComponent::Base
        extend Dry::Initializer[undefined: false]

        option :options
        option :attribute
        option :input
      end
    end
  end
end
