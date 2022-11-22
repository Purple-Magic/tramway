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
  s.summary     = 'Tramway Rails Engine'
  s.description = 'Tramway Rails Engine'
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
  s.add_dependency 'loofah', '>= 2.3.1'
  s.add_dependency 'mini_magick', '~> 4.8', '>= 4.8.0'
  s.add_dependency 'paranoia', '~> 2.2'
  s.add_dependency 'pg_search'
  s.add_dependency 'rmagick', '>= 2.16.0'
  s.add_dependency 'sass-rails', '~> 5.0', '>= 5.0.7'
  s.add_dependency 'simple_form', '>= 5.0.0'
  s.add_dependency 'tramway-auth', '>= 2.0.1'
  s.add_dependency 'tramway-user', '>= 2.1.3.2'
  s.add_dependency 'bootstrap-kaminari-views', '0.0.5'
  s.add_dependency 'copyright_mafa', '~> 0.1.2', '>= 0.1.2'
  s.add_dependency 'font-awesome-rails', '~> 4.7', '>= 4.7.0.1'
  s.add_dependency 'kaminari', '>= 1.1.1'
  s.add_dependency 'ransack'
  s.add_dependency 'smart_buttons', '>= 1.0'
  s.add_dependency 'state_machine_buttons', '>= 1.0'
  s.add_dependency 'trap', '~> 4.0'

  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
end
