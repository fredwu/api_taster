Rails.application.routes.draw do
  mount ApiTaster::Engine => "/api_taster"

  get 'home' => 'application#home', :as => :home

  resources :users, :except => [:new, :edit] do
    resources :comments, :only => [:new, :edit]
  end
end

ApiTaster.routes do
  get '/i_dont_exist_anymore', {
    :hello => 'world'
  }

  get '/users'

  post '/users', {
    :user => {
      :name => 'Fred',
      :comment => {
        :title => [1, 2, 3]
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
