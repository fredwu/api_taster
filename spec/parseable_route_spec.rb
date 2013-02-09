require 'spec_helper'
require File.expand_path('../../lib/api_taster/parseable_route', __FILE__)

describe ParseableRoute do

  class ActionDispatchRouteMock
    attr_reader :app, :verb
    def initialize(options)
    end
  end

  context "class methods" do
    describe '.discover_rack_app' do
      let(:rack_app) { Sprockets::Environment }
      let(:inner_app) { ActionDispatch::Routing::Mapper::Constraints.new(rack_app, {}) }
      let(:outer_app) { ActionDispatch::Routing::Mapper::Constraints.new(inner_app, {}) }
      let(:journey_route) { Journey::Route.new(nil, ApiTaster::Engine, nil, {}) }

      it "recursively finds rack apps from ActionDispatch::Routing::Mapper::Constraints apps" do
        ParseableRoute.discover_rack_app(outer_app).should == rack_app
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