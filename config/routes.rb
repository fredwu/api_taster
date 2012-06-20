ApiTaster::Engine.routes.draw do
  resources :routes, :only => [:index, :show]

  root :to => 'routes#index'
end
