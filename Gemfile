# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in tramway.gemspec.
gemspec

gem 'anyway_config', '2.5.4' # until Ruby 3.3.1 released

gem 'puma'

gem 'sqlite3'

gem 'sprockets-rails'

gem 'haml-rails'

gem 'dry-initializer'

group :development do
  gem 'reek'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
end
