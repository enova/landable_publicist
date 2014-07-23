class EmberController < ApplicationController
  def index
    render nothing: true, layout: 'publicist'
  end
end
