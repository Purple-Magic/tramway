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

          if assoc.present?
            Tramway::Decorators::NameBuilder.default_decorator_class_name(assoc.class).constantize.decorate(assoc)
          end
        end
      end
    end
  end
end
