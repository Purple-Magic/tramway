# frozen_string_literal: true

require 'tramway/warnings'
require 'tramway/errors'

module Tramway
  # Main controller for entities pages
  class EntitiesController < Tramway.config.application_controller.constantize
    prepend_view_path "#{Gem::Specification.find_by_name('tramway').gem_dir}/app/views"

    layout 'tramway/layouts/application'

    helper Tramway::ApplicationHelper
    include Rails.application.routes.url_helpers

    def index
      entities = base_entities
      entities = apply_filter(entities)
      entities = preload(entities)
      entities = search(entities)
      entities = entities.page(params[:page])
      @entities = entities

      @namespace = entity.namespace
      @filter_counts = filter_counts if filters.present?
    end

    def show
      @record = tramway_decorate(
        model_class.find(params.expect(:id)),
        namespace: entity.namespace
      ).with(view_context:)

      set_associations
    end

    def new
      @record = tramway_form model_class.new, namespace: entity.namespace
    end

    def edit
      @record = tramway_form model_class.find(params.expect(:id)), namespace: entity.namespace
    end

    # rubocop:disable Metrics/AbcSize
    def create
      @record = tramway_form model_class.new, namespace: entity.namespace

      if @record.submit params.require(model_class.model_name.param_key).permit!
        redirect_to Tramway::Engine.routes.url_helpers.public_send(entity.show_helper_method, @record.id),
                    notice: t('tramway.notices.created')
      else
        render :new
      end
    end

    def update
      @record = tramway_form model_class.find(params.expect(:id)), namespace: entity.namespace

      if @record.submit params.require(model_class.model_name.param_key).permit!
        redirect_to Tramway::Engine.routes.url_helpers.public_send(entity.show_helper_method, @record.id),
                    notice: t('tramway.notices.updated')
      else
        render :edit
      end
    end
    # rubocop:enable Metrics/AbcSize

    def destroy
      @record = model_class.find(params.expect(:id))

      @record.destroy

      redirect_to Tramway::Engine.routes.url_helpers.public_send(entity.index_helper_method),
                  notice: t('tramway.notices.deleted')
    end

    private

    def model_class
      @model_class ||= params[:entity][:name].classify.constantize
    end

    def entity
      @entity ||= Tramway.config.entities.find { |e| e.name == params[:entity][:name] }
    end

    def index_scope
      entity.page(:index).scope
    end

    def base_entities
      if index_scope.present?
        model_class.public_send(index_scope)
      else
        model_class.order(id: :desc)
      end
    end

    def filters
      entity.page(:index).filters
    end

    def apply_filter(entities)
      return entities if params[:filter].blank? || filters.blank?

      filter = params[:filter].to_s

      unless filters.map(&:to_s).include?(filter)
        raise Tramway::Errors::InvalidFilterError.new(filter:, available_filters: filters, model_class:)
      end

      entities.public_send(filter)
    end

    def filter_counts
      # Count by :id explicitly: a bare `.count` reuses any custom `select` values from the
      # index page's `scope` (e.g. a raw-SQL aliased subquery column), which breaks the
      # generated SQL. Counting a real column side-steps that entirely.
      filters.index_with { |filter| base_entities.public_send(filter).count(:id) }
    end

    def preload(entities)
      includes = entity.page(:index).includes

      includes.present? ? entities.includes(includes) : entities
    end

    def set_associations
      @associations = @record.send(:__show_associations, params[:page])
    end

    def search(entities)
      query = params[:query]

      if entity.page(:index).search && query.present?
        return entities.search(query) if entities.respond_to?(:search)

        Tramway::Warnings.search_fallback model_class

        return entities.tramway_search(query)
      end

      entities
    end
  end
end
