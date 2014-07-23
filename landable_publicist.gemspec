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
  s.add_dependency 'sass-rails', '~> 4.0.3'
  s.add_dependency 'compass-rails', '~> 1.0.3'
  s.add_dependency 'less-rails', '~> 2.3.3'
  s.add_dependency 'coffee-rails', '~> 4.0.0'
  s.add_dependency 'ember-rails', '~> 0.13.0'
  s.add_dependency 'ember-source', '1.0.0'
  s.add_dependency 'emblem-rails', '~> 0.1.1'
  s.add_dependency 'emblem-source', '0.3.2'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'haml-rails', '~> 0.4'
  s.add_dependency 'uglifier', '>= 1.3.0'
  s.add_dependency 'libv8', '~> 3.11.8'
  s.add_dependency 'jquery-fileupload-rails'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'simple_form'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'jbuilder', '~> 1.0.1'
  s.add_development_dependency 'active_model_serializers', '~> 0.8'
  s.add_development_dependency 'rest-client'
  s.add_development_dependency 'forgery'
  s.add_development_dependency 'factory_girl_rails', '~> 4.2'
  s.add_development_dependency 'database_cleaner', '= 1.0.0.RC1'
  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'cucumber',           '= 1.3.14'
  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'jasmine', '~> 1.3'
  s.add_development_dependency 'konacha', '~> 3.0.0'
  s.add_development_dependency 'sinon-rails', '~> 1.7.1.1'
  s.add_development_dependency 'sinon-chai-rails', '~> 1.0.3'
end

