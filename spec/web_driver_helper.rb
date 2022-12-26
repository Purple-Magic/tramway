# frozen_string_literal: true

require 'selenium/webdriver'
require 'webdrivers/chromedriver'

Capybara.server_host = '0.0.0.0'
Capybara.app_host = "http://#{ENV.fetch('HOSTNAME')}:#{Capybara.server_port}"
Capybara.server = :webrick
