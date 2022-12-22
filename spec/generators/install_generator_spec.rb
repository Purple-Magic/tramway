# frozen_string_literal: true

require 'generator_spec'

describe Tramway::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before(:all) do
    Tramway.initialize_application name: :test
    prepare_destination
    run_generator
  end

  context 'with initializers' do
    it 'creates a simple_form initializer' do
      assert_file 'config/initializers/simple_form.rb',
        File.readlines('lib/tramway/generators/templates/initializers/simple_form.rb')
    end

    it 'creates a simple_form_bootstrap initializer' do
      assert_file 'config/initializers/simple_form_bootstrap.rb',
        File.readlines('lib/tramway/generators/templates/initializers/simple_form_bootstrap.rb')
    end
  end
end
