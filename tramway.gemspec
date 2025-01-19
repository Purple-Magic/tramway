# frozen_string_literal: true

require_relative 'lib/tramway/version'

Gem::Specification.new do |spec|
  spec.name        = 'tramway'
  spec.version     = Tramway::VERSION
  spec.authors     = %w[kalashnikovisme moshiaan]
  spec.email       = ['kalashnikovisme@gmail.com']
  spec.homepage    = 'https://github.com/purple-magic/tramway'
  spec.summary     = 'Tramway Rails Engine'
  spec.description = 'Tramway Rails Engine'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/purple-magic/tramway'
  spec.metadata['changelog_uri'] = 'https://github.com/purple-magic/tramway'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'anyway_config'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'dry-struct'
  spec.add_dependency 'haml-rails'
  spec.add_dependency 'kaminari'
  spec.add_dependency 'rails', '>= 7', '< 9'
  spec.add_dependency 'view_component'
end
