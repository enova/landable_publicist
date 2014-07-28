require 'rails/generators'

module LandablePublicist
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates the LandablePublicist engine route'

      def add_landable_publicist_route
        route 'mount LandablePublicist::Engine => \'/\' # move this to the end of your routes block'
      end
    end
  end
end
