# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
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
require 'webdrivers/chromedriver'
require 'database_cleaner/active_record'
require 'support/web_driver_helper'

# Ensure the test database schema is up to date before running specs. This will
# load the schema or run migrations if needed so that ActiveRecord models have
# the required tables available.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::RSpecMatchers, type: :view
  config.include Capybara::RSpecMatchers, type: :controller
  config.include Capybara::RSpecMatchers, type: :decorator
  config.include FactoryBot::Syntax::Methods

  # Load factory definitions from the engine's spec/factories directory rather
  # than the dummy application's spec directory so FactoryBot can build test
  # objects correctly.
  config.before(:suite) do
    FactoryBot.definition_file_paths << File.expand_path('factories', __dir__)
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox disable-dev-shm-usage])
  )
end

# When Chrome is not available in the environment, fall back to Rack::Test so
# feature specs can still run (albeit without JavaScript support).
Capybara.default_driver = :rack_test
Capybara.javascript_driver = ENV['CAPYBARA_JS_DRIVER']&.to_sym || :rack_test

Capybara.register_driver :headless_chrome_mobile do |app|
  mobile_options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox
                                                                     disable-dev-shm-usage])
  mobile_options.add_argument('--window-size=375,812') # iPhone X dimensions

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: mobile_options
  )
end
