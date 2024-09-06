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
require 'webdrivers/chromedriver'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::RSpecMatchers, type: :view
  config.include Capybara::RSpecMatchers, type: :controller
  config.include Capybara::RSpecMatchers, type: :decorator
  config.include FactoryBot::Syntax::Methods

  config.after(:each, type: :feature) do |example|
    if example.exception
      # Capture the browser console logs
      logs = page.driver.browser.manage.logs.get(:browser)
      puts "\nBrowser console logs:\n"
      logs.each { |log| puts log.message }
    end
  end
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('no-sandbox')
  options.add_argument('disable-dev-shm-usage')
  
  # Enable logging
  options.add_preference('goog:loggingPrefs', browser: 'ALL')

  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :headless_chrome
