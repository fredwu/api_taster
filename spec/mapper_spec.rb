require 'spec_helper'

module ApiTaster
  describe Mapper do
    context "#global_params" do
      before(:all) do
        ApiTaster.global_params = { :foo => 'bar' }

        Route.map_routes "#{Rails.root}/lib/api_tasters/global_params"
      end

      it "merges params" do
        route = Route.find_by_verb_and_path(:get, '/dummy_users/:id')

        Route.supplied_params[route[:id]].should == [{ :foo => 'bar', :id => 1 }]
      end
    end

    context "non-existing routes" do
      before(:all) do
        ApiTaster.global_params = {}
        routes = ActionDispatch::Routing::RouteSet.new
        routes.draw do
          get '/awesome_route' => 'awesome#route'
        end

        Route.route_set = routes
        Route.map_routes "#{Rails.root}/lib/api_tasters/mapper"
      end

      it "records obsolete definitions" do
        Route.obsolete_definitions.first[:path].should == '/dummy_route'
      end
    end

    before(:all) do
      Rails.application.routes.draw do
        resources :dummy_users do
          member { map_method :patch, [:update] }
        end
      end

      Route.map_routes "#{Rails.root}/lib/api_tasters/mapper"
    end

    it "gets users" do
      route = Route.find_by_verb_and_path(:get, '/dummy_users/:id')

      Route.supplied_params[route[:id]].should == [{ :id => 1 }]
    end

    it "posts a new user" do
      route = Route.find_by_verb_and_path(:post, '/dummy_users')

      Route.supplied_params[route[:id]].should == [{}, { :hello => 'world' }]
    end

    it "edits a user" do
      route = Route.find_by_verb_and_path(:put, '/dummy_users/:id')

      Route.supplied_params[route[:id]].should == [{ :id => 2 }]
    end

    it "edits a user via PATCH" do
      route = Route.find_by_verb_and_path(:patch, '/dummy_users/:id')

      Route.supplied_params[route[:id]].should == [{ :id => 4 }]
    end

    it "deletes a user" do
      route = Route.find_by_verb_and_path(:delete, '/dummy_users/:id')

      Route.supplied_params[route[:id]].should == [{ :id => 3 }]
    end

    it "describes a route" do
      route = Route.find_by_verb_and_path(:get, '/dummy_users/:id')

      Route.comment_for(route).should == "Dummy user ID"
    end

    it "doesn't describe a route" do
      route = Route.find_by_verb_and_path(:post, '/dummy_users')

      Route.comment_for(route).should be_nil
    end

    it "meta data for a route" do
      route = Route.find_by_verb_and_path(:post, '/dummy_users')

      Route.metadata_for(route).should == { :meta => 'data' }
    end

    it "empty meta data for a route" do
      route = Route.find_by_verb_and_path(:get, '/dummy_users')

      Route.metadata_for(route).should == nil
    end
  end
end
