module Tramway
  module Configs
    module Entities
      class Route < Dry::Struct
        attribute? :namespace, Types::Coercible::String
        attribute? :route_method, Types::Coercible::String

        def helper_method_by(underscored_name)
          "#{[namespace, route_method || underscored_name].compact.join('_')}_path"
        end
      end
    end
  end
end
