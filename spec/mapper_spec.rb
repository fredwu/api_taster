require 'spec_helper'

module ApiTaster
  describe Mapper do
    before(:all) do
      Rails.application.routes.draw { resources :dummy_users }

      ApiTaster.routes do
        get '/dummy_users/:id', :id => 1
        post '/dummy_users'
        post '/dummy_users', { :hello => 'world' }
        put '/dummy_users/:id', :id => 2
        delete '/dummy_users/:id', :id => 3
      end
    end

    it "gets users" do
      route = Route.find_by_verb_and_path(:get, '/dummy_users/:id')

      Route.inputs[route[:id]].should == [{ :id => 1 }]
    end

    it "posts a new user" do
      route = Route.find_by_verb_and_path(:post, '/dummy_users')

      Route.inputs[route[:id]].should == [{}, { :hello => 'world' }]
    end

    it "edits a user" do
      route = Route.find_by_verb_and_path(:put, '/dummy_users/:id')

      Route.inputs[route[:id]].should == [{ :id => 2 }]
    end

    it "deletes a user" do
      route = Route.find_by_verb_and_path(:delete, '/dummy_users/:id')

      Route.inputs[route[:id]].should == [{ :id => 3 }]
    end
  end
end
