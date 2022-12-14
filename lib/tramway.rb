# frozen_string_literal: true

require 'tramway/engine'
require 'tramway/collection'
require 'tramway/collections/helper'
require 'font_awesome5_rails'
require 'pg_search'
require 'validators/presence_validator'
require 'tramway/singleton_models'
require 'tramway/records_models'
require 'tramway/forms'
require 'tramway/notifications'
require 'tramway/welcome_page_actions'
require 'tramway/navbar'
require 'tramway/error'
require 'tramway/generators/install_generator'
require 'tramway/tramway_model_helper'

module Tramway
  # Auth.layout_path = 'tramway/admin/application'

  class << self
    def initialize_application(**options)
      @application ||= Tramway::Application.new
      options.each do |attr, value|
        @application.send "#{attr}=", value
      end
    end

    def application_object
      if @application&.model_class.present?
        begin
          @application.model_class.first
        rescue StandardError
          nil
        end
      else
        @application
      end
    end

    def root
      File.dirname __dir__
    end

    attr_reader :application

    include ::Tramway::RecordsModels
    include ::Tramway::SingletonModels
    include ::Tramway::Forms
    include ::Tramway::Notifications
    include ::Tramway::WelcomePageActions
    include ::Tramway::Navbar

    attr_reader :customized_admin_navbar

    def engine_class(project)
      class_name = "::Tramway::#{project.to_s.camelize}"
      class_name.classify.safe_constantize
    end

    def project_is_engine?(project)
      engine_class(project)
    end

    def get_models_by_key(checked_models, project, role)
      unless project.present?
        error = Tramway::Error.new(
          plugin: :admin,
          method: :get_models_by_key,
          message: "Looks like you have not create at least one instance of #{Tramway.application.model_class} model OR Tramway Application Model is nil"
        )
        raise error.message
      end
      checked_models && checked_models[project]&.dig(role)&.keys || []
    end

    def models_array(models_type:, role:)
      instance_variable_get("@#{models_type}_models")&.map do |projects|
        projects.last[role]&.keys
      end&.flatten || []
    end

    def action_is_available?(record, project:, role:, model_name:, action:)
      project = project.underscore.to_sym unless project.is_a? Symbol
      actions = select_actions(project: project, role: role, model_name: model_name)
      availability = actions&.select do |a|
        if a.is_a? Symbol
          a == action.to_sym
        elsif a.is_a? Hash
          a.keys.first.to_sym == action.to_sym
        end
      end&.first

      return false unless availability.present?
      return true if availability.is_a? Symbol

      availability.values.first.call record
    end

    def select_actions(project:, role:, model_name:)
      stringify_keys(@singleton_models&.dig(project, role))&.dig(model_name) || stringify_keys(@available_models&.dig(project, role))&.dig(model_name)
    end

    def stringify_keys(hash)
      hash&.reduce({}) do |new_hash, pair|
        new_hash.merge! pair[0].to_s => pair[1]
      end
    end

    def admin_model
      auth_config.first[:user_model]
    end

    def auth_config
      @@auth_config ||= [{ user_model: ::Tramway::User, auth_attributes: :email }]
      @@auth_config
    end

    def auth_config=(params)
      if params.is_a? Hash
        @@auth_config = [params]
      elsif params.is_a? Array
        @@auth_config = params
      end
    end

    def user_based_models
      @@auth_config ||= []
      @@auth_config.map do |conf|
        conf[:user_model]
      end
    end

    def auth_attributes
      @@auth_config ||= []
      @@auth_config.reduce({}) do |hash, conf|
        hash.merge! conf[:user_model] => conf[:auth_attributes]
      end
    end

    def root_path_for=(**options)
      @root_path ||= {}
      @root_path.merge! options
    end

    def root_path_for(user_class)
      @root_path&.dig(user_class) || '/'
    end
  end
end

# HACK: FIXME

class ActiveModel::Errors
  def merge!(*args); end
end
