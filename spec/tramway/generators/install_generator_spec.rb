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

  def template_tailwind_config_path
    File.expand_path('../../../config/tailwind.config.js', __dir__)
  end

  def agents_path
    File.join(destination_root, 'AGENTS.md')
  end

  def remote_agents_content
    <<~MARKDOWN
      # Remote AGENTS content
      - Rule one
      - Rule two
    MARKDOWN
  end

  def wrapped_agents_content
    [
      '## Start of Tramway AGENTS.md',
      remote_agents_content.rstrip,
      '## End of Tramway AGENTS.md'
    ].join("\n")
  end

  before do
    response = instance_double(Net::HTTPResponse, body: remote_agents_content)
    allow(Net::HTTP).to receive(:get_response).and_return(response)
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
        "gem 'dry-initializer'"
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

  describe 'AGENTS instructions' do
    it 'creates AGENTS file from template when missing' do
      run_generator

      expect(File).to exist(agents_path)
      expect(File.read(agents_path)).to eq("#{wrapped_agents_content}\n")
    end

    it 'appends Tramway instructions to existing AGENTS file' do
      File.write(agents_path, '# Existing instructions')

      run_generator

      expect(File.read(agents_path)).to eq("# Existing instructions\n\n#{wrapped_agents_content}")
    end

    it 'replaces Tramway instructions between headers' do
      File.write(
        agents_path,
        <<~MARKDOWN
          # Existing instructions
          ## Start of Tramway AGENTS.md
          Old content
          ## End of Tramway AGENTS.md
          # Footer
        MARKDOWN
      )

      run_generator

      expect(File.read(agents_path)).to eq(
        <<~MARKDOWN
          # Existing instructions
          #{wrapped_agents_content}
          # Footer
        MARKDOWN
      )
    end

    it 'is idempotent when instructions already exist' do
      run_generator
      first_run = File.read(agents_path)

      run_generator
      second_run = File.read(agents_path)

      expect(second_run).to eq(first_run)
    end
  end
end
