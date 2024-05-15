# frozen_string_literal: true

module Tramway
  module Decorators
    # Decorate logic for decorating associations
    #
    module AssociationDecorator
      def associations(*associations)
        associations.each do |assoc|
          association assoc
        end
      end

      def association(association)
        define_method(association) do
          assoc = object.send(association)

          if assoc.is_a?(ActiveRecord::Relation)
            if assoc.empty?
              []
            else
              Tramway::Decorators::NameBuilder.default_decorator_class_name(assoc.klass).constantize.decorate(assoc)
            end
          elsif assoc.present?
            Tramway::Decorators::NameBuilder.default_decorator_class_name(assoc.class).constantize.decorate(assoc)
          end
        end
      end
    end
  end
end
