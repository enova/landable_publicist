$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "landable_publicist/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "landable_publicist"
  s.version     = LandablePublicist::VERSION
  s.authors     = ['Team Trogdor']
  s.email       = ['trogdor@enova.com']
  s.homepage    = 'https://github.com/enova/landable_publicist'
  s.summary     = 'Mountable CMS engine for Rails'
  s.description = "Landing page storage, rendering, tracking, and management FrontEnd / API"
  s.license     = 'MIT-LICENSE'

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'rails', '>= 4.0.0'
  s.add_dependency 'landable', '> 1.9.0'

  s.add_development_dependency 'pg'
end
