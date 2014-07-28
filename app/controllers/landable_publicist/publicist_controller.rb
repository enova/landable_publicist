module LandablePublicist
  class PublicistController < ActionController::Base
    def login
      render layout: 'publicist'
    end
  end
end
