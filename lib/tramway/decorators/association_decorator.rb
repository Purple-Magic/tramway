# frozen_string_literal: true

module Tramway
  module Decorators
    # Decorate logic for decorating associations
    #
    module AssociationDecorator
      private

      def decorate_has_many_association(assoc)
        assoc.empty? ? [] : decorate_associated_object(assoc, class_name: assoc.klass)
      end

      def decorate_associated_object(assoc, class_name: nil)
        decorator = Tramway::Decorators::NameBuilder.default_decorator_class_name(class_name || assoc.class).constantize

        decorator.decorate(assoc)
      end
    end
  end
end
