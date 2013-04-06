ApiTaster.routes do
  post '/dummy_users'
  post '/dummy_users', { :hello => 'world' }, { :meta => 'data' }
end
