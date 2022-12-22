# frozen_string_literal: true

module Tramway::RecordsModels
  def set_available_models(*models, project:, role: :admin)
    @available_models ||= {}
    @available_models[project] ||= {}
    @available_models[project][role] ||= {}
    models.each do |model|
      if model.instance_of?(Class) || model.instance_of?(String)
        @available_models[project][role].merge! model.to_s => %i[index show update create destroy]
      elsif model.instance_of?(Hash)
        @available_models[project][role].merge! model
      end
    end
    @available_models = @available_models.with_indifferent_access
  end

  def available_models_for(project, role: :admin)
    project = project.underscore.to_sym unless project.is_a? Symbol
    models = get_models_by_key(@available_models, project, role)
    if project_is_engine?(project)
      models += engine_class(project).dependencies.map do |dependency|
        if @available_models&.dig(dependency, role).present?
          @available_models&.dig(dependency, role)&.keys
        else
          error = Tramway::Error.new(
            method: :available_models_for,
            message: "There is no dependency `#{dependency}` for plugin: #{project}. Please, check file `tramway-#{project}/lib/tramway/#{project}/#{project}.rb`"
          )
          raise error
        end
      end.flatten.compact
    end
    # TODO: somehow cache results?
    models.map do |model|
      model.instance_of?(String) ? model.constantize : model
    end
  end

  def available_models(role:)
    models_array models_type: :available, role: role
  end
end
