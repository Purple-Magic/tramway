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

  def tailwind_shadcn_path
    File.join(destination_root, 'app/assets/tailwind/shadcn.css')
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

  def template_shadcn_stylesheet_path
    File.expand_path('../../../app/assets/stylesheets/shadcn.css', __dir__)
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
      expect(content.scan("'div-table-row'").count).to eq(1)
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
      expect(File.read(tailwind_application_path)).to eq(
        "@import \"tailwindcss\";\n" \
        "@import \"shadcn.css\";\n" \
        "@tailwind base;\n" \
        "@tailwind components;\n" \
        "@tailwind utilities;\n"
      )
    end

    it 'appends tailwind import when missing from existing file' do
      FileUtils.mkdir_p(File.dirname(tailwind_application_path))
      File.write(tailwind_application_path, 'body { color: black; }')

      run_generator

      content = File.read(tailwind_application_path)
      expect(content).to eq(
        "body { color: black; }\n" \
        "@import \"tailwindcss\";\n" \
        "@import \"shadcn.css\";\n" \
        "@tailwind base;\n" \
        "@tailwind components;\n" \
        "@tailwind utilities;\n"
      )
    end

    it 'does not duplicate the import line' do
      run_generator
      first_run = File.read(tailwind_application_path)

      run_generator
      second_run = File.read(tailwind_application_path)

      expect(second_run).to eq(first_run)
    end
  end

  describe 'tailwind shadcn stylesheet' do
    it 'creates stylesheet from template when missing' do
      run_generator

      expect(File).to exist(tailwind_shadcn_path)
      expect(File.read(tailwind_shadcn_path)).to eq(File.read(template_shadcn_stylesheet_path))
    end

    it 'does not overwrite an existing stylesheet' do
      FileUtils.mkdir_p(File.dirname(tailwind_shadcn_path))
      File.write(tailwind_shadcn_path, 'body { color: black; }')

      run_generator

      expect(File.read(tailwind_shadcn_path)).to eq('body { color: black; }')
    end
  end

  describe 'importmap pins' do
    it 'appends tramway controller pins when importmap exists' do
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
        "pin \"@tramway/tramway-select\", to: \"tramway/tramway-select_controller.js\"\n" \
        "pin \"@tramway/table-row-preview\", to: \"tramway/table_row_preview_controller.js\"\n"
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
    it 'appends tramway controller imports and registrations when index exists' do
      FileUtils.mkdir_p(File.dirname(controllers_index_path))
      File.write(controllers_index_path, base_index_content)

      run_generator

      expect(File.read(controllers_index_path)).to eq(
        <<~JS
          import { Application } from "@hotwired/stimulus"
          import { UserForm } from "./user_form_controller"
          import { TramwaySelect } from "@tramway/tramway-select"
          import { TableRowPreview } from "@tramway/table-row-preview"

          const application = Application.start()

          application.debug = false
          window.Stimulus   = application
          application.register('user-form', UserForm)

          application.register('tramway-select', TramwaySelect)
          application.register('table-row-preview', TableRowPreview)
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
