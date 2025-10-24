# frozen_string_literal: true

require 'rails/generators'

module Tramway
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Installs Tramway dependencies and Tailwind safelist configuration.'

      def ensure_dependencies
        missing_dependencies = gem_dependencies.reject do |dependency|
          gemfile_contains?(dependency[:name])
        end

        return if missing_dependencies.empty?

        append_to_file 'Gemfile', <<~GEMS

# Tramway dependencies
#{missing_dependencies.map { |dependency| dependency[:declaration] }.join("\n")}

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

      private

      def gem_dependencies
        @gem_dependencies ||= [
          { name: 'haml-rails', declaration: 'gem "haml-rails"' },
          { name: 'kaminari', declaration: 'gem "kaminari"' },
          { name: 'view_component', declaration: 'gem "view_component"' },
          { name: 'dry-initializer', declaration: "gem 'dry-initializer'" }
        ]
      end

      def gemfile_path
        @gemfile_path ||= File.join(destination_root, 'Gemfile')
      end

      def gemfile_contains?(name)
        return false unless File.exist?(gemfile_path)

        content = File.read(gemfile_path)
        content.match?(/^\s*gem ['\"]#{Regexp.escape(name)}['\"]/)
      end

      def tailwind_config_path
        @tailwind_config_path ||= File.join(destination_root, 'config/tailwind.config.js')
      end

      def gem_tailwind_config_path
        @gem_tailwind_config_path ||= File.expand_path('../../../../config/tailwind.config.js', __dir__)
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
    end
  end
end
