# frozen_string_literal: true

require 'selenium/webdriver'
require 'webdrivers/chromedriver'

Capybara.server_host = "0.0.0.0"
Capybara.app_host = "http://#{ENV.fetch("HOSTNAME")}:#{Capybara.server_port}"

# Capybara.register_driver :chrome do |app|
#   profile = Selenium::WebDriver::Chrome::Profile.new
#   profile['download.default_directory'] = File.expand_path('tmp/files')

#   Capybara::Selenium::Driver.new app, browser: :chrome, profile: profile
# end

# Capybara.configure do |config|
#   config.default_max_wait_time = 3
#   if ENV['EB'] == 'true'
#     config.default_driver = :chrome
#     config.javascript_driver = :chrome
#   else
#     config.default_driver = :selenium_chrome_headless
#     config.javascript_driver = :selenium_chrome_headless
#   end
# end

# Webdrivers::Chromedriver.required_version = '107.0.5304.62'

# Capybara.always_include_port = true
# Capybara.raise_server_errors = false
Capybara.server = :webrick
