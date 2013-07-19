ApiTaster.routes do
  get '/dummy_route'
  desc "Dummy user ID"
  get '/dummy_users/:id', :id => 1
  post '/dummy_users'
  post '/dummy_users', { :hello => 'world' }, { :meta => 'data' }
  put '/dummy_users/:id', :id => 2
  delete '/dummy_users/:id', :id => 3
  patch '/dummy_users/:id', :id => 4
end
