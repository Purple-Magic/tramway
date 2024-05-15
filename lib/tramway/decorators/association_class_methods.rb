# frozen_string_literal: true

module Tramway
  module Decorators
    # Module for defining association class-level methods
    #
    module AssociationClassMethods
      def associations(*associations)
        associations.each do |assoc|
          association assoc
        end
      end

      # has_and_belongs_to_many is not supported for now
      def association(association)
        define_method(association) do
          assoc = object.send(association)

          if assoc.is_a?(ActiveRecord::Relation)
            decorate_has_many_association assoc
          elsif assoc.present?
            decorate_associated_object assoc
          end
        end
      end
    end
  end
end
