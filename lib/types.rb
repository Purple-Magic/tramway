# frozen_string_literal: true

require 'dry-struct'

# We need because of this https://dry-rb.org/gems/dry-struct/1.6/recipes/
module Types
  include Dry.Types()
end
