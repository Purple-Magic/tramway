# frozen_string_literal: true

require 'rails/generators'
require 'tramway/core/generators'

class Tramway::Core::Generators::InstallGenerator < ::Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

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
end
