# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'tramway/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'tramway'
  s.version     = Tramway::VERSION
  s.authors     = ['Pavel Kalashnikov', 'moshiaan']
  s.email       = ['kalashnikovisme@gmail.com']
  s.homepage    = 'https://github.com/purple-magic/tramway'
  s.summary     = 'Core for all Tramway Rails Engines'
  s.description = 'Core for all Tramway Rails Engines'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'aasm'
  s.add_dependency 'audited', '>= 4.8.0'
  s.add_dependency 'bootstrap', '>= 4.1.2'
  s.add_dependency 'carrierwave'
  s.add_dependency 'ckeditor', '4.2.4'
  s.add_dependency 'clipboard-rails'
  s.add_dependency 'enumerize', '~> 2.1', '>= 2.1.2'
  s.add_dependency 'font_awesome5_rails'
  s.add_dependency 'haml-rails'
  s.add_dependency 'kaminari'
  s.add_dependency 'loofah', '>= 2.3.1'
  s.add_dependency 'mini_magick', '~> 4.8', '>= 4.8.0'
  s.add_dependency 'paranoia', '~> 2.2'
  s.add_dependency 'pg_search'
  s.add_dependency 'rmagick', '>= 2.16.0'
  s.add_dependency 'sass-rails', '~> 5.0', '>= 5.0.7'
  s.add_dependency 'simple_form', '>= 5.0.0'

  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
end
