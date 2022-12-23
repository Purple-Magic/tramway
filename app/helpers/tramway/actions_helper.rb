# frozen_string_literal: true

module Tramway::ActionsHelper
  def create_is_available?(model_class)
    Tramway.action_is_available?(
      nil,
      project: (@application_engine || @application.name),
      model_name: model_class,
      role: current_user.role,
      action: :create
    )
  end

  def update_is_available?(object)
    Tramway.action_is_available?(
      object,
      project: (@application_engine || @application.name),
      model_name: object.model.class.name,
      role: current_user.role,
      action: :update
    )
  end

  def destroy_is_available?(object)
    Tramway.action_is_available?(
      object,
      project: (@application_engine || @application.name),
      model_name: object.model.class.name,
      role: current_user.role,
      action: :destroy
    )
  end

  # delete_button is in smart-buttons gem

  def edit_button(url:, button_options:, &block)
    link_to(url, **button_options, &block)
  end

  def habtm_destroy_is_available?(association_object, main_object)
    main_model_name = main_object.model.class.to_s.underscore.pluralize

    Tramway.forms&.include?("#{main_model_name}/remove_#{association_object.model.class.to_s.underscore}")
  end
end
