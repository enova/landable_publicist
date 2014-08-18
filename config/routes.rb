LandablePublicist::Engine.routes.draw do
  scope module: 'public', as: :public do
    get  '/publicist' => 'publicist#index', as: :publicist
  end
end
