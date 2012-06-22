ApiTaster::Engine.routes.draw do
  resources :routes, :only => [:index, :show] do
    collection do
      get :missing_definitions
      get :obsolete_definitions
    end
  end

  root :to => 'routes#index'
end
