# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'puma'

gem 'sprockets-rails'

gem 'sqlite3'

gem 'haml-rails'

gem 'view_component'

group :development, :test do
  gem 'debug', '>= 1.0.0'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
end
