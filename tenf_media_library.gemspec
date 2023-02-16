require_relative "lib/tenf_media_library/version"

Gem::Specification.new do |spec|
  spec.name        = "tenf_media_library"
  spec.version     = TenfMediaLibrary::VERSION
  spec.authors     = ["Connor Deachman"]
  spec.email       = ["connor@10fdesign.io"]
  # spec.homepage    = "TODO"
  spec.summary     = "10F Media Library"
  spec.description = "10F's media library gem"
  spec.license     = "MIT"


  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'rails', ">= 6.0.3.5"
  spec.add_dependency 'administrate'
  spec.add_dependency 'administrate-field-active_storage'
  spec.add_dependency 'image_processing'
  spec.add_dependency 'simple_form'

end
