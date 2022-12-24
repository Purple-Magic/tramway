# frozen_string_literal: true

require 'rails/generators'
require 'tramway/generators'
require 'tramway/generators/model_generator'

class Tramway::Generators::InstallGenerator < ::Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  class_option :user_role, type: :string, default: 'admin'
  include Rails::Generators::Migration

  def run_other_generators
    generate 'audited:install'
  end

  def self.next_migration_number(path)
    next_migration_number = current_migration_number(path) + 1
    ActiveRecord::Migration.next_migration_number next_migration_number
  end

  def copy_initializer
    simple_form_files = %w[simple_form simple_form_bootstrap]
    simple_form_files.each do |file|
      copy_file(
        "/#{File.dirname __dir__}/generators/templates/initializers/#{file}.rb",
        "config/initializers/#{file}.rb"
      )
    end
  end

  def copy_migrations
    migrations = %i[
      create_tramway_users
    ]

    migrations.each do |migration|
      migration_template "#{migration}.rb", "db/migrate/#{migration}.rb"
    end
  end

  def run_decorator_generators
    Tramway::Error.raise_error(:tramway, :generators, :install) unless Tramway.application.present?

    project = Tramway.application.name
    Tramway.available_models_for(project).map do |model|
      generate 'tramway:model', model.to_s, "--user-role=#{options[:user_role]}"
    end
  end
end
