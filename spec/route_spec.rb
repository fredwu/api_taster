require 'spec_helper'

module ApiTaster
  describe Route do
    let(:app_home_route) do
      {
        :id   => 0,
        :name => 'home',
        :verb => 'GET',
        :path => '/home',
        :reqs => {
          :controller => 'application',
          :action => 'home'
        }
      }
    end

    before(:all) do
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        get 'home' => 'application#home', :as => :home
        resources :users do
          resources :comments
        end
        mount Rails.application => '/app'
        mount proc {} => '/rack_app'
      end

      Route.route_set = routes
    end

    it "#routes" do
      Route.routes.first.should == app_home_route
    end

    it "#grouped_routes" do
      Route.grouped_routes.has_key?('application').should == true
      Route.grouped_routes.has_key?('users').should == true
      Route.grouped_routes.has_key?('comments').should == true
      Route.grouped_routes['application'][0].should == app_home_route
    end

    it "#find" do
      Route.find(0).should == app_home_route
      Route.find(999).should == nil
    end

    it "#find_by_verb_and_path" do
      Route.find_by_verb_and_path(:get, '/home').should == app_home_route
      Route.find_by_verb_and_path(:get, '/dummy').should == nil
      Route.find_by_verb_and_path(:delete, '/home').should == nil
    end

    it "#inputs_for" do
      Route.stub(:routes).and_return([{
        :id   => 0,
        :path => '/dummy/:dummy_id'
      }, {
        :id   => 999,
        :path => 'a_non_existing_dummy',
        :verb => 'get'
      }])
      Route.inputs[0] = [{ :dummy_id => 1, :hello => 'world' }]

      Route.inputs_for(Route.find(999)).should have_key(:undefined)

      2.times do
        Route.inputs_for(Route.find(0)).should == [{
          :url_params  => { :dummy_id => 1 },
          :post_params => { :hello => 'world' }
        }]
      end
    end

    it "#missing_definitions" do
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw do
        get 'awesome_route' => 'awesome#route'
      end
      Rails.application.stub(:routes).and_return(routes)
      ApiTaster.routes do
        # nothing
      end

      Route.missing_definitions.first[:path].should == '/awesome_route'
    end

    context "private methods" do
      it "#discover_rack_app" do
        klass = Class.new
        klass.stub_chain(:class, :name).and_return(ActionDispatch::Routing::Mapper::Constraints)
        klass.stub(:app).and_return('klass')

        Route.send(:discover_rack_app, klass).should == 'klass'
      end

      it "#discover_rack_app" do
        Route.send(:discover_rack_app, ApiTaster::Engine).should == ApiTaster::Engine
      end
    end
  end
end
