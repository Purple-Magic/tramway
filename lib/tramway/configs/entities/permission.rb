# frozen_string_literal: true

module Tramway
  module Configs
    module Entities
      # Route struct describes rules for route management
      #
      class Permission < Dry::Struct
        attribute? :adapter, Types::Coercible::String
      end
    end
  end
end
