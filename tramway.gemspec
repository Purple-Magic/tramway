require_relative "lib/tramway/version"

Gem::Specification.new do |spec|
  spec.name        = "tramway"
  spec.version     = Tramway::VERSION
  spec.authors     = %w[kalashnikovisme moshiaan]
  spec.email       = ['kalashnikovisme@gmail.com']
  spec.homepage    = 'https://github.com/purple-magic/tramway'
  spec.summary     = 'Tramway Rails Engine'
  spec.description = 'Tramway Rails Engine'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/purple-magic/tramway"
  spec.metadata["changelog_uri"] = "https://github.com/purple-magic/tramway"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "~> 7"
  spec.add_dependency "view_component"
  
  spec.add_development_dependency "rspec-rails"
end
