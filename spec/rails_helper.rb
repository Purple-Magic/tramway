require File.expand_path('../dummy/config/environment', __FILE__)

require 'spec_helper'
require "rspec/rails"
require "view_component/test_helpers"
require "view_component/system_test_helpers"
require "capybara/rspec"

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
end
