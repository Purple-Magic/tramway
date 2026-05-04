# frozen_string_literal: true

require 'rails/generators'
require 'fileutils'

module Tramway
  module Generators
    # nodoc
    # rubocop:disable Metrics/ModuleLength
    module InstallGeneratorHelpers
      private

      def gem_dependencies
        @gem_dependencies ||= [
          { name: 'haml-rails', declaration: 'gem "haml-rails"' },
          { name: 'kaminari', declaration: 'gem "kaminari"' },
          { name: 'view_component', declaration: 'gem "view_component"' },
          { name: 'dry-initializer', declaration: "gem 'dry-initializer'" },
          { name: 'dry-monads', declaration: "gem 'dry-monads'" }
        ]
      end

      def gemfile_path
        @gemfile_path ||= File.join(destination_root, 'Gemfile')
      end

      def gemfile_contains?(name)
        return false unless File.exist?(gemfile_path)

        content = File.read(gemfile_path)
        content.match?(/^\s*gem ['"]#{Regexp.escape(name)}['"]/)
      end

      def tailwind_config_path
        @tailwind_config_path ||= File.join(destination_root, 'config/tailwind.config.js')
      end

      def gem_tailwind_config_path
        @gem_tailwind_config_path ||= File.expand_path('../../../../config/tailwind.config.js', __dir__)
      end

      def tailwind_application_stylesheet_path
        @tailwind_application_stylesheet_path ||= File.join(destination_root, 'app/assets/tailwind/application.css')
      end

      def tailwind_css_import_line
        '@import "tailwindcss";'
      end

      def importmap_path
        @importmap_path ||= File.join(destination_root, 'config/importmap.rb')
      end

      def controllers_index_path
        @controllers_index_path ||= File.join(destination_root, 'app/javascript/controllers/index.js')
      end

      def importmap_tramway_select_pin
        'pin "@tramway/tramway-select", to: "tramway/tramway-select_controller.js"'
      end

      def importmap_table_row_preview_pin
        'pin "@tramway/table-row-preview", to: "tramway/table_row_preview_controller.js"'
      end

      def importmap_tramway_pins
        [importmap_tramway_select_pin, importmap_table_row_preview_pin]
      end

      def stimulus_controller_imports
        [
          'import { TramwaySelect } from "@tramway/tramway-select"',
          'import { TableRowPreview } from "@tramway/table-row-preview"'
        ]
      end

      def stimulus_controller_registrations
        [
          "application.register('tramway-select', TramwaySelect)",
          "application.register('table-row-preview', TableRowPreview)"
        ]
      end

      def agents_file_path
        @agents_file_path ||= File.join(destination_root, 'AGENTS.md')
      end

      def codex_agents_instruction
        'If you are Codex, use the tramway-skill skill for Tramway/Rails work in this project. ' \
          'If tramway-skill is not installed, install it from https://github.com/Purple-Magic/tramway-skill/.'
      end

      def create_tailwind_config
        create_file tailwind_config_path, File.read(gem_tailwind_config_path)
      end

      def extract_safelist_entries(content)
        section = safelist_section(content)
        return [] if section.nil?

        section.scan(/'([^']+)'/).flatten.map(&:strip).reject(&:empty?).uniq
      end

      def safelist_section(content)
        match = content.match(/safelist\s*:\s*\[(.*?)\]\s*,?/m)
        match&.[](1)
      end

      def insert_entries(content, entries)
        match = content.match(/safelist\s*:\s*\[(.*?)\](\s*,?)/m)
        return content unless match

        closing_index = match.begin(0) + match[0].rindex(']')
        indentation = closing_indentation(content, closing_index)
        formatted_entries = entries.map { |entry| "#{indentation}'#{entry}',\n" }.join

        needs_leading_newline = content[closing_index - 1] != "\n"
        insertion = String.new
        insertion << "\n" if needs_leading_newline
        insertion << formatted_entries

        content.dup.insert(closing_index, insertion)
      end

      def closing_indentation(content, index)
        line_start = content.rindex("\n", index - 1) || 0
        line = content[line_start..index]
        line[/^\s*/] || '  '
      end

      def append_codex_agents_instruction(content)
        separator = agents_separator(content)
        "#{content}#{separator}#{codex_agents_instruction}\n"
      end

      def agents_separator(content)
        return '' if content.empty?

        content.end_with?("\n") ? "\n" : "\n\n"
      end

      # rubocop:disable Metrics/MethodLength
      def append_missing_imports(content)
        missing_imports = stimulus_controller_imports.reject { |line| content.include?(line) }
        return content if missing_imports.empty?

        import_lines = content.each_line.with_index.filter_map do |line, index|
          index if line.lstrip.start_with?('import ')
        end
        insertion = "#{missing_imports.join("\n")}\n"
        updated = content.dup

        if import_lines.any?
          insertion_index = updated.lines[0..import_lines.max].join.length
          updated.insert(insertion_index, insertion)
        else
          updated.prepend(insertion)
        end

        updated
      end
      # rubocop:enable Metrics/MethodLength

      def append_missing_registrations(content)
        missing_registrations = stimulus_controller_registrations.reject { |line| content.include?(line) }
        return content if missing_registrations.empty?

        insertion = "#{missing_registrations.join("\n")}\n"
        export_match = /^(?:export\s*\{[^}]+\}\s*;?\s*)$/m.match(content)

        return content.dup.insert(export_match.begin(0), insertion) if export_match

        updated = content.dup
        updated << "\n" unless updated.empty? || updated.end_with?("\n")
        updated << insertion
        updated
      end

      def with_agents_update_fallback
        yield
      rescue StandardError => e
        say_status(:warning, "Skipping AGENTS.md update: #{e.message}")
      end
    end
    # rubocop:enable Metrics/ModuleLength

    # Running `rails generate tramway:install` will invoke this generator
    #
    class InstallGenerator < Rails::Generators::Base
      include InstallGeneratorHelpers

      desc 'Installs Tramway dependencies and Tailwind safelist configuration.'

      def ensure_agents_file
        with_agents_update_fallback do
          return create_file(agents_file_path, "#{codex_agents_instruction}\n") unless File.exist?(agents_file_path)

          content = File.read(agents_file_path)
          return if content.include?(codex_agents_instruction)

          updated = append_codex_agents_instruction(content)
          return if updated == content

          File.write(agents_file_path, updated, mode: 'w:UTF-8')
        end
      end

      def ensure_dependencies
        missing_dependencies = gem_dependencies.reject do |dependency|
          gemfile_contains?(dependency[:name])
        end

        return if missing_dependencies.empty?

        append_to_file 'Gemfile', <<~GEMS

          # Tramway dependencies
          #{missing_dependencies.pluck(:declaration).join("\n")}

        GEMS
      end

      def ensure_tailwind_safelist
        return create_tailwind_config unless File.exist?(tailwind_config_path)

        source_entries = extract_safelist_entries(File.read(gem_tailwind_config_path))
        target_content = File.read(tailwind_config_path)
        target_entries = extract_safelist_entries(target_content)

        missing_entries = source_entries - target_entries
        return if missing_entries.empty?

        File.write(tailwind_config_path, insert_entries(target_content, missing_entries))
      end

      def ensure_tailwind_application_stylesheet
        path = tailwind_application_stylesheet_path
        FileUtils.mkdir_p(File.dirname(path))

        return create_file(path, "#{tailwind_css_import_line}\n") unless File.exist?(path)

        content = File.read(path)
        return if content.include?(tailwind_css_import_line)

        File.open(path, 'a') do |file|
          file.write("\n") unless content.empty? || content.end_with?("\n")
          file.write("#{tailwind_css_import_line}\n")
        end
      end

      def ensure_importmap_pin
        return unless File.exist?(importmap_path)

        content = File.read(importmap_path)
        missing_pins = importmap_tramway_pins.reject { |pin| content.include?(pin) }
        return if missing_pins.empty?

        File.open(importmap_path, 'a') do |file|
          file.write("\n") unless content.empty? || content.end_with?("\n")
          file.write("#{missing_pins.join("\n")}\n")
        end
      end

      def ensure_stimulus_controller_registration
        return unless File.exist?(controllers_index_path)

        content = File.read(controllers_index_path)
        updated = append_missing_imports(content)
        updated = append_missing_registrations(updated)
        return if updated == content

        File.write(controllers_index_path, updated)
      end
    end
  end
end
