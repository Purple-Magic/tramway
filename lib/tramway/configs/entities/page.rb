# frozen_string_literal: true

module Tramway
  module Configs
    module Entities
      # Route struct describes rules for route management
      #
      class Page < Dry::Struct
        attribute :action, Types::Coercible::String
        attribute? :scope, Dry::Types::Definition.new(Proc).optional.default(nil)
      end
    end
  end
end
