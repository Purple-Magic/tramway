# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in tramway.gemspec.
gemspec

gem 'aasm'
gem 'anyway_config'
gem 'dry-initializer'
gem 'haml-rails'
gem 'kaminari'
gem 'puma'
gem 'sprockets-rails'
gem 'sqlite3', '~> 1.4'
gem 'importmap-rails'

group :development do
  gem 'reek'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
