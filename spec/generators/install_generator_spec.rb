# frozen_string_literal: true

require 'generator_spec'

describe Tramway::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)
  let(:errors) do
    YAML.load_file('spec/yaml/errors.yml')['generators']
  end

  before(:all) do
    prepare_destination
  end

  context 'without initialized Tramway application' do
    it 'raises RuntimeError' do
      expect(run_generator).to raise_error RuntimeError, errors['generators']['without_initialized_tramway_application']['raises_runtime_error']
    end
  end

  it 'creates a simple_form initializer' do
    assert_file 'config/initializers/simple_form.rb', '# Initializer'
  end
end
