require_dependency "landable_publicist/application_controller"

module LandablePublicist
  module Public
    class PublicistController < ApplicationController
      def index
        render layout: 'landable_publicist/publicist'
      end
    end
  end
end
