# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'tramway/version'

Gem::Specification.new do |s|
  s.name        = 'tramway'
  s.version     = Tramway::VERSION
  s.authors     = ['kalashnikovisme', 'moshiaan']
  s.email       = ['kalashnikovisme@gmail.com']
  s.homepage    = 'https://github.com/purple-magic/tramway'
  s.summary     = 'Tramway Rails Engine'
  s.description = 'Tramway Rails Engine'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 7'
end
