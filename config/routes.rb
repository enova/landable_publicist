LandablePublicist::Engine.routes.draw do
  get '/publicist', to: 'publicist#login'


  # Landable!
  mount Landable::Engine => '/'
end
