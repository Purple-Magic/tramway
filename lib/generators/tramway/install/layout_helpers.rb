# frozen_string_literal: true

module Tramway
  module Generators
    # Layout helpers for Tramway generator template updates.
    module InstallGeneratorLayoutHelpers
      private

      def application_layout_haml_path
        @application_layout_haml_path ||= File.join(destination_root, 'app/views/layouts/application.html.haml')
      end

      def application_layout_erb_path
        @application_layout_erb_path ||= File.join(destination_root, 'app/views/layouts/application.html.erb')
      end

      def trix_haml_tags
        "    = stylesheet_link_tag \"trix\", \"data-turbo-track\": \"reload\"\n    " \
          "= javascript_include_tag \"trix\", \"data-turbo-track\": \"reload\", defer: true\n"
      end

      def trix_erb_tags
        "    <%= stylesheet_link_tag \"trix\", \"data-turbo-track\": \"reload\" %>\n    " \
          "<%= javascript_include_tag \"trix\", \"data-turbo-track\": \"reload\", defer: true %>\n"
      end

      def trix_already_present?(content)
        content.include?('stylesheet_link_tag "trix"') || content.include?("stylesheet_link_tag 'trix'")
      end

      def font_awesome_already_present?(content)
        content.include?('stylesheet_link_tag "font-awesome"') ||
          content.include?("stylesheet_link_tag 'font-awesome'")
      end

      def navbar_sidebar_offset_class
        'md:pl-72 transition-all duration-300 ease-in-out'
      end

      def ensure_trix_in_haml_layout
        content = File.read(application_layout_haml_path)
        return if trix_already_present?(content)
        return unless content.match?(/^\s+%body/)

        updated = content.sub(/^(\s+%body)/, "#{trix_haml_tags}\\1")
        File.write(application_layout_haml_path, updated)
      end

      def ensure_trix_in_erb_layout
        content = File.read(application_layout_erb_path)
        return if trix_already_present?(content)
        return unless content.include?('</head>')

        updated = content.sub('</head>', "#{trix_erb_tags}  </head>")
        File.write(application_layout_erb_path, updated)
      end

      def ensure_navbar_sidebar_offset
        if File.exist?(application_layout_haml_path)
          ensure_navbar_sidebar_offset_in_haml_layout
        elsif File.exist?(application_layout_erb_path)
          ensure_navbar_sidebar_offset_in_erb_layout
        end
      end

      def ensure_navbar_sidebar_offset_in_haml_layout
        content = File.read(application_layout_haml_path)
        return if content.include?(navbar_sidebar_offset_class)
        return unless content.match?(/= tramway_main_container(?: class: '[^']*')? do/)

        File.write(
          application_layout_haml_path,
          content.sub(
            /= tramway_main_container(?: class: '[^']*')? do/,
            "= tramway_main_container class: '#{navbar_sidebar_offset_class}' do"
          )
        )
      end

      def ensure_navbar_sidebar_offset_in_erb_layout
        content = File.read(application_layout_erb_path)
        return if content.include?(navbar_sidebar_offset_class)
        return unless content.match?(/<%= tramway_main_container(?: class: '[^']*')? do %>/)

        File.write(
          application_layout_erb_path,
          content.sub(
            /<%= tramway_main_container(?: class: '[^']*')? do %>/,
            "<%= tramway_main_container class: '#{navbar_sidebar_offset_class}' do %>"
          )
        )
      end
    end
  end
end
