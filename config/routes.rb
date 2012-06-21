ApiTaster::Engine.routes.draw do
  resources :routes, :only => [:index, :show] do
    get :obsolete_definitions, :on => :collection
  end

  root :to => 'routes#index'
end
