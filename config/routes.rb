LandablePublicist::Engine.routes.draw do
  get '/publicist' => 'ember#index'

  # Landable Engine
  mount Landable::Engine => '/'
end
