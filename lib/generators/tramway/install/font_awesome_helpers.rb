# frozen_string_literal: true

module Tramway
  module Generators
    # nodoc
    module InstallGeneratorFontAwesomeHelpers
      private

      def font_awesome_already_present?(content)
        content.include?('stylesheet_link_tag "font-awesome"') ||
          content.include?("stylesheet_link_tag 'font-awesome'")
      end

      def ensure_font_awesome_in_haml_layout
        content = File.read(application_layout_haml_path)
        return if font_awesome_already_present?(content)
        return unless content.match?(/^\s+= stylesheet_link_tag "tailwind", "data-turbo-track": "reload"/)

        updated = content.sub(
          /^(\s+= stylesheet_link_tag "tailwind", "data-turbo-track": "reload"\n)/,
          "\\1    = stylesheet_link_tag \"font-awesome\", \"data-turbo-track\": \"reload\"\n"
        )
        File.write(application_layout_haml_path, updated)
      end

      def ensure_font_awesome_in_erb_layout
        content = File.read(application_layout_erb_path)
        return if font_awesome_already_present?(content)
        return unless content.include?('</head>')

        updated = content.sub(
          /(\s+<%= stylesheet_link_tag "tailwind", "data-turbo-track": "reload" %>\n)/,
          "\\1    <%= stylesheet_link_tag \"font-awesome\", \"data-turbo-track\": \"reload\" %>\n"
        )
        File.write(application_layout_erb_path, updated)
      end
    end
  end
end
