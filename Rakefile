# frozen_string_literal: true

require 'bundler/setup'

# The dummy Rails application used for testing lives under `spec/dummy`
# rather than the legacy `test/dummy` path. Update the rakefile reference
# accordingly so Rails tasks load correctly during test runs.
APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

# Define the RSpec task so `rake spec` runs the suite when invoked
require 'rspec/core/rake_task'

desc 'Run the RSpec suite'
RSpec::Core::RakeTask.new(:spec)

task default: :spec
