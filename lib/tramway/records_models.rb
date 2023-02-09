# frozen_string_literal: true

module Tramway::RecordsModels
  def set_available_models(models, project:, role: :admin)
    initialize_available_models_for project, role

    if !models.is_a?(Array) && !models.is_a?(Hash)
      Tramway::Error.raise_error :records, :wrong_available_models_type
    end

    if models.is_a? Array
      models.each do |model|
        if model.instance_of?(Class) || model.instance_of?(String)
          @available_models[project][role].merge! model.to_s => %i[index show update create destroy]
        elsif model.instance_of?(Hash)
          @available_models[project][role].merge! model
        end
      end
    end

    if models.is_a? Hash
      @available_models[project][role].merge! models
    end
    @available_models = @available_models.with_indifferent_access
  end

  def available_models_for(project, role: :admin)
    project = project.underscore.to_sym unless project.is_a? Symbol
    models = get_models_by_key(@available_models, project, role)
    models = available_models_for_engine(project, role, models) if project_is_engine?(project)

    models.map do |model|
      model.instance_of?(String) ? model.constantize : model
    end
  end

  def available_models(role:)
    models_array models_type: :available, role: role
  end

  def clear_available_models!
    @available_models = {}
  end

  private

  def initialize_available_models_for(project, role)
    @available_models ||= {}
    @available_models[project] ||= {}
    @available_models[project][role] ||= {}
  end

  def available_models_for_engine(project, role, models)
    models + engine_class(project).dependencies.map do |dependency|
      if @available_models&.dig(dependency, role).present?
        @available_models&.dig(dependency, role)&.keys
      else
        Tramway::Error.raise_error :records, :there_is_no_dependency, dependency: dependency, project: project
      end
    end.flatten.compact
  end
end
