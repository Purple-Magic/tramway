# frozen_string_literal: true

require 'rack/utils'

module Tramway
  module Decorators
    # Builds metadata for associations rendered on Tramway entity show pages.
    module ShowAssociations
      private

      def __show_associations(page)
        show_associations.map do |(association, options)|
          __show_association(association, options || {}, page)
        end.compact
      end

      def __show_association(association, options, page)
        reflection = __reflection_for_show_association(association)
        association_type = reflection.macro
        association_options = __association_options(association, association_type, options, page)
        new_record_path = __association_new_record_path(reflection, association_options.delete(:new_record_path))

        {
          name: association,
          association_type:,
          new_record_path:,
          **association_options
        }
      end

      def __reflection_for_show_association(association)
        reflection = object.class.reflect_on_association(association)

        return reflection if reflection.present?

        raise "You must define #{association} association in the #{object.class}"
      end

      def __association_options(association, association_type, options, page)
        send("__#{association_type}_associations", association, options, page)
      end

      def __association_new_record_path(reflection, new_record_path)
        new_record_path = __inferred_association_new_record_path(reflection) if new_record_path.blank?

        return if new_record_path.blank?

        __new_record_path_with_redirect(new_record_path)
      end

      def __inferred_association_new_record_path(reflection)
        association_entity = __entity_for_name(reflection.class_name.underscore)

        return if association_entity.blank? || association_entity.page(:create).blank?

        Tramway::Engine.routes.url_helpers.public_send(association_entity.new_helper_method)
      end

      def __new_record_path_with_redirect(new_record_path)
        redirect_path = __entity_show_path

        return new_record_path if redirect_path.blank?

        separator = new_record_path.include?('?') ? '&' : '?'

        "#{new_record_path}#{separator}#{Rack::Utils.build_query(redirect: redirect_path)}"
      end

      def __entity_show_path
        entity = __entity_for_name(object.class.name.underscore)

        return if entity.blank? || entity.page(:show).blank?

        Tramway::Engine.routes.url_helpers.public_send(entity.show_helper_method, object.id)
      end

      def __entity_for_name(name)
        Tramway.config.entities.find do |config_entity|
          config_entity.name == name
        end
      end

      def __has_many_associations(association, options, page)
        records = Kaminari.paginate_array(public_send(association.name)).page(page)

        {
          decorator: records.first&.class,
          records:,
          model_class: records.first&.object&.class,
          new_record_path: options[:new_record_path]
        }
      end

      def __belongs_to_associations(association, _options, _page)
        record = public_send(association.name)

        { decorator: record.class, record:, model_class: record.class }
      end
    end
  end
end
