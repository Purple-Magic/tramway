# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in tramway.gemspec.
gemspec

gem 'aasm'
gem 'anyway_config'
gem 'dry-initializer'
gem 'haml-rails'
gem 'importmap-rails'
gem 'kaminari'
gem 'puma'
gem 'sprockets-rails'
gem 'stimulus-rails'

group :development do
  gem 'appraisal'
  gem 'reek'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'base64'
  gem 'capybara'
  gem 'database_cleaner-active_record'
  gem 'drb'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'mutex_m'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :development, :test do
  gem 'debug'
end
