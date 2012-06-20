require 'spec_helper'

module ApiTaster
  describe RoutesController do
    it "#index" do
      get :index, :use_route => :api_taster

      assigns(:routes).should be_kind_of(Hash)
    end

    it "#show" do
      Route.stub(:find).and_return(Route.new)
      Route.stub(:inputs_for).and_return([])

      get :show, :id => 1, :use_route => :api_taster

      assigns(:route).should be_kind_of(Route)
      assigns(:inputs).should be_kind_of(Array)
    end
  end
end
