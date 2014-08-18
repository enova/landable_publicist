$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "landable_publicist/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "landable_publicist"
  s.version     = LandablePublicist::VERSION::STRING
  s.authors     = ['Team Trogdor']
  s.email       = ['trogdor@enova.com']
  s.homepage    = 'https://github.com/enova/landable_publicist'
  s.summary     = 'Mountable CMS engine for Rails'
  s.description = "Landing page storage, rendering, tracking, and management FrontEnd / API"
  s.license     = 'MIT-LICENSE'

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'rails', '>= 4.0.0'
  s.add_dependency 'active_model_serializers', '~> 0.8'
  s.add_dependency 'carrierwave'
  s.add_dependency 'liquid'
  s.add_dependency 'fog'
  s.add_dependency 'rest-client'
  s.add_dependency 'builder'
  s.add_dependency 'lookup_by', '> 0.4.0'
  s.add_dependency 'bcrypt-ruby'

  s.add_dependency 'sass-rails', '~> 4.0.3'
  s.add_dependency 'compass-rails', '~> 1.0.3'
  s.add_dependency 'less-rails', '~> 2.3.3'
  s.add_dependency 'coffee-rails', '~> 4.0.0'
  s.add_dependency 'ember-rails'
  s.add_dependency 'ember-source', '1.0.0'
  s.add_dependency 'emblem-rails'
  s.add_dependency 'emblem-source', '0.3.2'
  s.add_dependency 'handlebars_assets'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails',        '~> 2.14.2'
  s.add_development_dependency 'factory_girl_rails', '~> 4.2.0'
  s.add_development_dependency 'json-schema',        '= 2.1.3'
  s.add_development_dependency 'rack-schema'
  s.add_development_dependency 'cucumber',           '= 1.3.14'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'valid_attribute'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'faker'

  s.add_development_dependency 'haml-rails', '~> 0.4'
  s.add_development_dependency 'uglifier', '>= 1.3.0'
  s.add_development_dependency 'libv8', '~> 3.11.8'
  s.add_development_dependency 'therubyracer', '~> 0.11.3'
  s.add_development_dependency 'jquery-fileupload-rails'
  s.add_development_dependency 'font-awesome-rails'
  s.add_development_dependency 'simple_form'
end