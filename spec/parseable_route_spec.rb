require 'spec_helper'
require File.expand_path('../../lib/api_taster/parseable_route', __FILE__)

describe ParseableRoute do

  class ActionDispatchRouteMock
    attr_reader :name, :path, :verb, :app

    def initialize(options={})
      @name = options[:name] || 'mock_route'
      @verb = options[:verb] || 'GET|POST'
      @path = options[:path] || '/users(.:format)'
      @requirements = options[:requirements] || {action: 'index', controller: 'users'}
      @app = options[:app] || ActionDispatch::Routing::RouteSet.new
    end
  end

  let(:mock_route) { ActionDispatchRouteMock.new }
  let(:real_routes) { ActionDispatch::Routing::RouteSet.new }
  let(:home_route) { real_routes.routes.first }
  let(:dual_route) { real_routes.routes.to_a[1] }

  before do
    real_routes.draw do
      get 'home' => 'application#home', :as => :home
      match 'dual_action' => 'dummy/action', :via => [:get, :delete]
      resources :users do
        resources :comments
      end
      mount Rails.application => '/app'
      mount proc {} => '/rack_app'
    end
  end

  context 'retrieving a sanitized path' do
    it 'from an ActionDispatch::Routing::Route' do
      ParseableRoute.new(mock_route).sanitized_path.should == '/users'
    end

    it 'from a Journey::Route' do
      ParseableRoute.new(home_route).sanitized_path.should == '/home'
    end
  end

  context 'retrieving verbs' do
    it 'from an ActionDispatch::Routing::Route' do
      ParseableRoute.new(mock_route).verbs.should == ['GET', 'POST']
    end

    it 'from a Journey::Route' do
      ParseableRoute.new(home_route).verbs.should == ['GET']
      ParseableRoute.new(dual_route).verbs.should == ['GET', 'DELETE']
    end
  end

  describe '#normalisable' do
    let(:it_is_not_normalisable) { ParseableRoute.new(mock_route).normalisable?.should be_false }

    it 'is false for ActionDispatch::Routing::Mapper::Constraints' do
      mock_route.app.stub(:is_a?).with(ActionDispatch::Routing::Mapper::Constraints).and_return(true)
      it_is_not_normalisable
    end

    it 'is false for Sprockets::Environment' do
      mock_route.stub(:app).and_return(Sprockets::Environment.new)
      it_is_not_normalisable
    end

    it 'is false for ApiTaster::Engine' do
      mock_route.stub(:app).and_return(ApiTaster::Engine)
      it_is_not_normalisable
    end

    it 'is false if the verb is empty' do
      mock_route.stub(:verb).and_return(//)
      it_is_not_normalisable

      mock_route.stub(:verb).and_return('')
      it_is_not_normalisable
    end

    # there is probably a better way to assert normalisability
    it 'defaults to true in the absence of any of the above conditions' do
      ParseableRoute.new(mock_route).normalisable?.should be_true
      ParseableRoute.new(home_route).normalisable?.should be_true
    end
  end

  context "class methods" do
    let(:rack_app) { Sprockets::Environment }
    let(:inner_app) { ActionDispatch::Routing::Mapper::Constraints.new(rack_app, {}) }
    let(:outer_app) { ActionDispatch::Routing::Mapper::Constraints.new(inner_app, {}) }
    let(:journey_route) { Journey::Route.new(nil, ApiTaster::Engine, nil, {}) }

    describe '.discover_rack_app' do
      context 'for ActionDispatch::Routing::Mapper::Constraints' do
        it 'recursively finds rack apps' do
          klass = Class.new
          klass.stub(:class).and_return(ActionDispatch::Routing::Mapper::Constraints)
          klass.stub(:app).and_return('klass')

          ParseableRoute.discover_rack_app(klass).should == 'klass'
        end

        it 'goes multiple levels down recursively if necessary' do
          ParseableRoute.discover_rack_app(outer_app).should == rack_app
        end
      end

      it "returns the app for anything not in the ActionDispatch::Routing namespace" do
        ParseableRoute.discover_rack_app(journey_route.app).should == ApiTaster::Engine
      end

      it "returns nil if the app is in the ActionDispatch::Routing namespace but is not Mapper::Constraints" do
        ParseableRoute.discover_rack_app(ActionDispatch::Routing::RouteSet.new).should be_nil
      end
    end
  end

end