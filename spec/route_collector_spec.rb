require 'spec_helper'

module ApiTaster
  describe RouteCollector do
    before(:all) do
      Rails.application.routes.draw do
        resources :dummy_users
      end
      Route.map_routes "#{Rails.root}/lib/api_tasters/route_collector"
    end

    it "gets users" do
      route = Route.find_by_verb_and_path(:get, '/dummy_users/:id')
      Route.supplied_params[route[:id]].should == [{ :id => 42 }]
    end

    it "posts a new user" do
      route = Route.find_by_verb_and_path(:post, '/dummy_users')
      Route.supplied_params[route[:id]].should == [{}, { :hello => 'world' }]
    end
  end
end
