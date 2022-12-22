# frozen_string_literal: true

require 'generator_spec'

describe Tramway::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before(:all) do
    prepare_destination
  end

  it 'creates a simple_form initializer' do
    assert_file 'config/initializers/simple_form.rb', '# Initializer'
  end
end
