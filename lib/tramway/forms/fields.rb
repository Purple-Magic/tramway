module Tramway
  module Forms
    module Fields
      module ClassMethods
        def fields(**attributes)
          @fields.merge! attributes
        end

        def __initialize_fields(subclass)
          subclass.instance_variable_set(:@fields, {})
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end
