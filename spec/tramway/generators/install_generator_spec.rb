# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'fileutils'
require 'stringio'
require 'generators/tramway/install/install_generator'

RSpec.describe Tramway::Generators::InstallGenerator do
  let(:destination_root) { Dir.mktmpdir }

  after do
    FileUtils.rm_rf(destination_root)
  end

  def run_generator
    File.write(gemfile_path, "source 'https://rubygems.org'\n") unless File.exist?(gemfile_path)

    generator = described_class.new
    generator.destination_root = destination_root
    generator.invoke_all
  end

  def gemfile_path
    File.join(destination_root, 'Gemfile')
  end

  def tailwind_config_path
    File.join(destination_root, 'config/tailwind.config.js')
  end

  def tailwind_application_path
    File.join(destination_root, 'app/assets/tailwind/application.css')
  end

  def importmap_path
    File.join(destination_root, 'config/importmap.rb')
  end

  def controllers_index_path
    File.join(destination_root, 'app/javascript/controllers/index.js')
  end

  def template_tailwind_config_path
    File.expand_path('../../../config/tailwind.config.js', __dir__)
  end

  def agents_path
    File.join(destination_root, 'AGENTS.md')
  end

  def codex_agents_instruction
    'If you are Codex, use the tramway-skill skill for Tramway/Rails work in this project. ' \
      'If tramway-skill is not installed, install it from https://github.com/Purple-Magic/tramway-skill/.'
  end

  describe 'ensuring gem dependencies' do
    before do
      File.write(gemfile_path, "source 'https://rubygems.org'\n")
    end

    it 'appends missing dependencies once' do
      run_generator

      content = File.read(gemfile_path)

      expect(content).to include('# Tramway dependencies')
      [
        'gem "haml-rails"',
        'gem "kaminari"',
        'gem "view_component"',
        "gem 'dry-initializer'",
        "gem 'dry-monads'"
      ].each do |dependency|
        expect(content.scan(dependency).count).to eq(1)
      end
    end

    it 'does not duplicate dependencies when run multiple times' do
      run_generator
      first_run = File.read(gemfile_path)

      run_generator
      second_run = File.read(gemfile_path)

      expect(second_run).to eq(first_run)
    end
  end

  describe 'tailwind config safelist' do
    it 'creates config file from template when missing' do
      run_generator

      expect(File).to exist(tailwind_config_path)
      expect(File.read(tailwind_config_path)).to eq(File.read(template_tailwind_config_path))
    end

    it 'merges missing safelist entries into existing config' do
      FileUtils.mkdir_p(File.dirname(tailwind_config_path))
      File.write(
        tailwind_config_path,
        <<~JS
          module.exports = {
            safelist: [
              'div-table'
            ],
          }
        JS
      )

      run_generator

      content = File.read(tailwind_config_path)
      expect(content.scan("'div-table'").count).to eq(1)
      expect(content.scan("'text-zinc-200'").count).to eq(1)
    end

    it 'is idempotent when config already contains safelist' do
      run_generator
      first_run = File.read(tailwind_config_path)

      run_generator
      second_run = File.read(tailwind_config_path)

      expect(second_run).to eq(first_run)
    end
  end

  describe 'tailwind application stylesheet' do
    it 'creates stylesheet with tailwind import when missing' do
      run_generator

      expect(File).to exist(tailwind_application_path)
      expect(File.read(tailwind_application_path)).to eq("@import \"tailwindcss\";\n")
    end

    it 'appends tailwind import when missing from existing file' do
      FileUtils.mkdir_p(File.dirname(tailwind_application_path))
      File.write(tailwind_application_path, 'body { color: black; }')

      run_generator

      content = File.read(tailwind_application_path)
      expect(content).to eq("body { color: black; }\n@import \"tailwindcss\";\n")
    end

    it 'does not duplicate the import line' do
      run_generator
      first_run = File.read(tailwind_application_path)

      run_generator
      second_run = File.read(tailwind_application_path)

      expect(second_run).to eq(first_run)
    end
  end

  describe 'importmap pins' do
    it 'appends the tramway JavaScript pin when importmap exists' do
      FileUtils.mkdir_p(File.dirname(importmap_path))
      File.write(importmap_path, 'pin "application", preload: true')

      run_generator

      expect(File.read(importmap_path)).to eq(
        "pin \"application\", preload: true\n" \
        "pin \"@tailwindcss/forms\", to: \"tailwindcss/forms.js\"\n" \
        "pin \"@tailwindcss/typography\", to: \"tailwindcss/typography.js\"\n" \
        "pin \"@tailwindcss/aspect-ratio\", to: \"tailwindcss/aspect-ratio.js\"\n" \
        "pin \"@tailwindcss/container-queries\", to: \"tailwindcss/container-queries.js\"\n" \
        "pin \"tailwindcss-animate\", to: \"tailwindcss-animate.js\"\n" \
        "pin \"@tramway/tramway\", to: \"tramway/tramway.js\"\n"
      )
    end

    it 'does not create importmap when missing' do
      run_generator

      expect(File).not_to exist(importmap_path)
    end

    it 'does not duplicate the pin when run multiple times' do
      FileUtils.mkdir_p(File.dirname(importmap_path))
      File.write(importmap_path, 'pin "application", preload: true')

      run_generator
      first_run = File.read(importmap_path)

      run_generator
      second_run = File.read(importmap_path)

      expect(second_run).to eq(first_run)
    end

    it 'replaces legacy tramway pins with the single tramway pin' do
      FileUtils.mkdir_p(File.dirname(importmap_path))
      File.write(importmap_path, <<~RUBY)
        pin "@tramway/tramway-select", to: "tramway/tramway-select_controller.js"
        pin "@tramway/table-row-preview", to: "tramway/table_row_preview_controller.js"
        pin "@tramway/ui-checkbox", to: "tramway/ui_checkbox_controller.js"
        pin "@tramway/tooltip", to: "tramway/tooltip_controller.js"
      RUBY

      run_generator

      content = File.read(importmap_path)
      expect(content.scan('@tramway/tramway').count).to eq(1)
      expect(content).to include('pin "@tramway/tramway", to: "tramway/tramway.js"')
      expect(content).not_to match(%r{@tramway/(?:tramway-select|table-row-preview|ui-checkbox|tooltip)})
    end
  end

  describe 'stimulus controllers index' do
    let(:base_index_content) do
      <<~JS
        import { Application } from "@hotwired/stimulus"
        import { UserForm } from "./user_form_controller"

        const application = Application.start()

        application.debug = false
        window.Stimulus   = application
        application.register('user-form', UserForm)

        export { application }
      JS
    end

    # rubocop:disable RSpec/ExampleLength
    it 'appends the tramway controller import and registrations when index exists' do
      FileUtils.mkdir_p(File.dirname(controllers_index_path))
      File.write(controllers_index_path, base_index_content)

      run_generator

      expect(File.read(controllers_index_path)).to eq(
        <<~JS
          import { Application } from "@hotwired/stimulus"
          import { UserForm } from "./user_form_controller"
          import { TramwaySelect, TableRowPreview, UiCheckbox, Tooltip } from "@tramway/tramway"

          const application = Application.start()

          application.debug = false
          window.Stimulus   = application
          application.register('user-form', UserForm)

          application.register('tramway-select', TramwaySelect)
          application.register('table-row-preview', TableRowPreview)
          application.register('ui--checkbox', UiCheckbox)
          application.register('tramway-tooltip', Tooltip)
          export { application }
        JS
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it 'does not create controllers index when missing' do
      run_generator

      expect(File).not_to exist(controllers_index_path)
    end

    it 'does not duplicate tramway controller entries when run multiple times' do
      FileUtils.mkdir_p(File.dirname(controllers_index_path))
      File.write(controllers_index_path, base_index_content)

      run_generator
      first_run = File.read(controllers_index_path)

      run_generator
      second_run = File.read(controllers_index_path)

      expect(second_run).to eq(first_run)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'replaces legacy tramway imports with the single tramway import' do
      FileUtils.mkdir_p(File.dirname(controllers_index_path))
      File.write(controllers_index_path, <<~JS)
        import { Application } from "@hotwired/stimulus"
        import { TramwaySelect } from "@tramway/tramway-select"
        import { TableRowPreview } from "@tramway/table-row-preview"
        import { UiCheckbox } from "@tramway/ui-checkbox"
        import { Tooltip } from "@tramway/tooltip"

        const application = Application.start()

        application.register('tramway-select', TramwaySelect)
        application.register('table-row-preview', TableRowPreview)
        application.register('ui--checkbox', UiCheckbox)
        application.register('tramway-tooltip', Tooltip)
        export { application }
      JS

      run_generator

      content = File.read(controllers_index_path)
      expect(content.scan('UiCheckbox').count).to eq(2)
      expect(content).to include(
        'import { TramwaySelect, TableRowPreview, UiCheckbox, Tooltip } from "@tramway/tramway"'
      )
      expect(content).not_to match(%r{@tramway/(?:tramway-select|table-row-preview|ui-checkbox|tooltip)})
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'trix tags in application layout' do
    def haml_layout_path
      File.join(destination_root, 'app/views/layouts/application.html.haml')
    end

    def erb_layout_path
      File.join(destination_root, 'app/views/layouts/application.html.erb')
    end

    def minimal_haml_layout
      <<~HAML
        %html
          %head
            = stylesheet_link_tag "application", "data-turbo-track": "reload"
            = javascript_importmap_tags
          %body
            = yield
      HAML
    end

    def minimal_erb_layout
      <<~ERB
        <!DOCTYPE html>
        <html>
          <head>
            <title>App</title>
            <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
            <%= javascript_importmap_tags %>
          </head>
          <body>
            <%= yield %>
          </body>
        </html>
      ERB
    end

    context 'with a HAML layout' do
      before do
        FileUtils.mkdir_p(File.dirname(haml_layout_path))
        File.write(haml_layout_path, minimal_haml_layout)
      end

      it 'inserts trix stylesheet and javascript tags before %body' do
        run_generator

        content = File.read(haml_layout_path)

        expect(content).to include('= stylesheet_link_tag "trix", "data-turbo-track": "reload"')
        expect(content).to include('= javascript_include_tag "trix", "data-turbo-track": "reload", defer: true')
        expect(content.index('stylesheet_link_tag "trix"')).to be < content.index('%body')
      end

      it 'does not insert trix tags when already present' do
        run_generator
        first_run = File.read(haml_layout_path)

        run_generator
        second_run = File.read(haml_layout_path)

        expect(second_run).to eq(first_run)
        expect(second_run.scan('stylesheet_link_tag "trix"').count).to eq(1)
      end
    end

    context 'with an ERB layout' do
      before do
        FileUtils.mkdir_p(File.dirname(erb_layout_path))
        File.write(erb_layout_path, minimal_erb_layout)
      end

      it 'inserts trix stylesheet and javascript tags before </head>' do
        run_generator

        content = File.read(erb_layout_path)

        expect(content).to include('stylesheet_link_tag "trix", "data-turbo-track": "reload"')
        expect(content).to include('javascript_include_tag "trix", "data-turbo-track": "reload", defer: true')
        expect(content.index('stylesheet_link_tag "trix"')).to be < content.index('</head>')
      end

      it 'does not insert trix tags when already present' do
        run_generator
        first_run = File.read(erb_layout_path)

        run_generator
        second_run = File.read(erb_layout_path)

        expect(second_run).to eq(first_run)
        expect(second_run.scan('stylesheet_link_tag "trix"').count).to eq(1)
      end
    end

    context 'when no application layout exists' do
      it 'does not raise an error' do
        expect { run_generator }.not_to raise_error
      end
    end
  end

  describe 'AGENTS instructions' do
    it 'creates AGENTS file with Codex tramway-skill instruction when missing' do
      run_generator

      expect(File).to exist(agents_path)
      expect(File.read(agents_path)).to eq("#{codex_agents_instruction}\n")
    end

    it 'appends Codex tramway-skill instruction to existing AGENTS file' do
      File.write(agents_path, '# Existing instructions')

      run_generator

      expect(File.read(agents_path)).to eq("# Existing instructions\n\n#{codex_agents_instruction}\n")
    end

    it 'does not duplicate Codex tramway-skill instruction when run multiple times' do
      run_generator
      first_run = File.read(agents_path)

      run_generator
      second_run = File.read(agents_path)

      expect(second_run).to eq(first_run)
    end
  end
end
