# frozen_string_literal: true

module Tramway
  # Main controller for entities pages
  class EntitiesController < Tramway.config.application_controller.constantize
    prepend_view_path "#{Gem::Specification.find_by_name('tramway').gem_dir}/app/views"

    layout 'tramway/layouts/application'

    helper Tramway::ApplicationHelper
    include Rails.application.routes.url_helpers

    def index
      if index_scope.present?
        model_class.public_send(index_scope)
      else
        model_class.order(id: :desc)
      end.page(params[:page]) => entities

      @entities = tramway_decorate entities, namespace: entity.namespace

      @namespace = entity.namespace
    end

    def show
      @record = tramway_decorate(
        model_class.find(params[:id]),
        namespace: entity.namespace
      ).with(view_context:)

      set_associations
    end

    def new
      @record = tramway_form model_class.new, namespace: entity.namespace
    end

    def edit
      @record = tramway_form model_class.find(params[:id]), namespace: entity.namespace
    end

    # rubocop:disable Metrics/AbcSize
    def create
      @record = tramway_form model_class.new, namespace: entity.namespace

      if @record.submit params[model_class.model_name.param_key]
        redirect_to public_send(entity.show_helper_method, @record.id), notice: t('tramway.notices.created')
      else
        render :new
      end
    end

    def update
      @record = tramway_form model_class.find(params[:id]), namespace: entity.namespace

      if @record.submit params[model_class.model_name.param_key]
        redirect_to public_send(entity.show_helper_method, @record.id), notice: t('tramway.notices.updated')
      else
        render :edit
      end
    end
    # rubocop:enable Metrics/AbcSize

    def destroy
      @record = model_class.find(params[:id])

      @record.destroy

      redirect_to public_send(entity.index_helper_method), notice: t('tramway.notices.deleted')
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

    def set_associations
      @associations = @record.show_associations.map do |association|
        next unless @record.public_send(association).any?

        records = Kaminari.paginate_array(@record.public_send(association.name)).page(params[:page])

        {
          name: association,
          decorator: records.first.class,
          records:
        }
      end.compact
    end
  end
end
