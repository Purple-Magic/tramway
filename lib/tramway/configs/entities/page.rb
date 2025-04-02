# frozen_string_literal: true

module Tramway
  module Configs
    module Entities
      # Route struct describes rules for route management
      #
      class Page < Dry::Struct
        attribute :action, Types::Coercible::String
        attribute? :scope, Types::Coercible::String
      end
    end
  end
end
