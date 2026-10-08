# frozen_string_literal: true

module Tramway
  module Configs
    module Entities
      # Route struct describes rules for route management
      #
      class Page < Dry::Struct
        attribute :action, Types::Coercible::String
        attribute? :scope, Types::Coercible::String
        attribute? :search, Types::Bool
        attribute? :includes, Types::Array.default([].freeze)
        attribute? :filters, Types::Array.default([].freeze)
        attribute? :member, Types::Bool.default(false)
        attribute? :via, (Types::Coercible::Symbol | Types::Array.of(Types::Coercible::Symbol)).default(:get)
        attribute? :params, Types::Array.of(Types::Coercible::Symbol).default([].freeze)
      end
    end
  end
end
