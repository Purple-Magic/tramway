require "generator_spec"

describe Tramway::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  context 'without initialized Tramway application' do
    assert 
  end

  it 'creates a simple_form initializer' do
    assert_file 'config/initializers/simple_form.rb', "# Initializer"
  end
end
