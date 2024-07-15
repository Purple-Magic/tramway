# frozen_string_literal: true

require File.expand_path('dummy/config/environment', __dir__)

require 'spec_helper'
require 'rspec/rails'
require 'view_component/test_helpers'
require 'view_component/system_test_helpers'
require 'capybara/rspec'
require 'faker'
require 'tramway/helpers/navbar_helper'
require 'tramway/navbar'
require 'factory_bot_rails'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::RSpecMatchers, type: :view
  config.include Capybara::RSpecMatchers, type: :controller
  config.include Capybara::RSpecMatchers, type: :decorator
  config.include FactoryBot::Syntax::Methods
end
