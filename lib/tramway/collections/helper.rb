# frozen_string_literal: true

require 'tramway/collections'

module Tramway
  module Collections
    module Helper
      def collection_list_by(name:)
        begin
          require name # needed to load class name with collection
        rescue LoadError
          raise "No such file #{name}. You should create file in the `lib/#{name}.rb` or elsewhere you want"
        end
        unless ::Tramway::Collection.descendants.map(&:to_s).include?(name.camelize)
          ::Tramway::Error.raise_error(
            :tramway, :collections, :helper, :collection_list_by, :there_no_such_collection,
            name_camelize: name.camelize
          )
        end

        name.camelize.constantize.list
      end
    end
  end
end
