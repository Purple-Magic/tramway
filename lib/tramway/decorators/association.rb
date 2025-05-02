# frozen_string_literal: true

module Tramway
  module Decorators
    # Module for defining association instance-level methods
    module Association
      private

      # :reek:UtilityFunction { enabled: false }
      def decorate_has_many_association(assoc)
        AssocDecoratorHelper.decorate_has_many_association(assoc)
      end
    end

    # Module for defining association class-level methods
    #
    module AssociationClassMethods
      def associations(*associations)
        associations.each do |assoc|
          association assoc
        end
      end

      # has_and_belongs_to_many is not supported for now
      def association(association, decorator: nil)
        define_method(association) do
          assoc = object.send(association)

          if assoc.is_a?(ActiveRecord::Relation)
            AssocDecoratorHelper.decorate_has_many_association assoc
          elsif assoc.present?
            AssocDecoratorHelper.decorate_associated_object(assoc)
          end
        end
      end
    end

    # Helper module for association decorators
    module AssocDecoratorHelper
      class << self
        def decorate_has_many_association(assoc, decorator_class: nil)
          return [] if assoc.empty?
          
          decorator_class ||= decorator(assoc.klass)

          decorator_class.decorate(assoc)
        end

        def decorate_associated_object(assoc, decorator_class: nil)
          decorator_class ||= decorator(assoc.class)

          decorator_class.decorate(assoc)
        end

        def decorator(class_name)
          Tramway::Decorators::NameBuilder.default_decorator_class_name(class_name).constantize
        end
      end
    end
  end
end
