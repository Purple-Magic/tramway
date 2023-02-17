# frozen_string_literal: true

module Tramway::SingletonModels
  def set_singleton_models(*models, project:, role: :admin)
    @singleton_models ||= {}
    @singleton_models[project] ||= {}
    @singleton_models[project][role] ||= {}
    models.each do |model|
      if model.instance_of?(Class)
        @singleton_models[project][role].merge! model.to_s => %i[index show update create destroy]
      elsif model.instance_of?(Hash)
        @singleton_models[project][role].merge! model.to_s
      end
    end
    @singleton_models = @singleton_models.with_indifferent_access
  end

  def singleton_models_for(project, role: :admin)
    project = project.underscore.to_sym unless project.is_a? Symbol
    models = get_models_by_key(@singleton_models, project, role)
    if project_is_engine?(project)
      models += engine_class(project).dependencies.map do |dependency|
        @singleton_models&.dig(dependency, role)&.keys
      end.flatten.compact
    end
    models
  end

  def singleton_models(role:)
    models_array models_type: :singleton, role:
  end
end
