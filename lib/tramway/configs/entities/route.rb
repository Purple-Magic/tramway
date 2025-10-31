# frozen_string_literal: true

module Tramway
  module Configs
    module Entities
      # Route struct describes rules for route management
      #
      class Route < Dry::Struct
        attribute? :route_method, Types::Coercible::String

        def helper_method_by(underscored_name)
          "#{route_method || underscored_name}_path"
        end
      end
    end
  end
end
