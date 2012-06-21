Rails.application.routes.draw do
  mount ApiTaster::Engine => "/api_taster"

  get 'home' => 'application#home', :as => :home

  resources :users, :except => [:new, :edit] do
    resources :comments, :only => [:new, :edit]
  end
end

ApiTaster.routes do
  get '/users'

  post '/users', {
    :user => {
      :name => 'Fred',
      :comment => {
        :title => 'hi!'
      }
    }
  }

  get '/users/:id', {
    :id => 1
  }

  put '/users/:id', {
    :id => 1, :user => {
      :name => 'Awesome'
    }
  }

  delete '/users/:id', {
    :id => 1
  }
end
