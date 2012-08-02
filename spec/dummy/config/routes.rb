Rails.application.routes.draw do
  mount ApiTaster::Engine => "/api_taster"

  get 'home' => 'application#home', :as => :home
  match 'custom' => 'application#home', :via => [:get, :delete]

  resources :users, :except => [:new, :edit] do
    resources :comments, :only => [:new, :edit]
  end
end

ApiTaster.routes do
  get '/i_dont_exist_anymore', {
    :hello => 'world'
  }

  desc 'Get a __list__ of users.'
  get '/users'

  post '/users', {
    :hello => 'world',
    :user => {
      :name => 'Fred',
      :comment => {
        :title => [1, 2, 3]
      }
    },
    :items => [
      { :name => 'flower', :price => '4.95' },
      { :name => 'pot', :price => '2.45' },
      { :nested_items => [
        { :name => 'apple' },
        { :name => 'orange'},
        { :nested_numbers => [3, 4, 5] },
        { :name => 'banana'}
      ]}
    ]
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
