require 'spec_helper'

module ApiTaster
  describe RoutesController do
    context "missing ApiTaster.routes" do
      it "#index" do
        Route.stub(:mappings).and_return(nil)
        get :index, :use_route => :api_taster

        response.should be_success
        assigns(:routes).should be_kind_of(Hash)
      end
    end

    it "#index" do
      get :index, :use_route => :api_taster

      assigns(:routes).should be_kind_of(Hash)
    end

    it "#show" do
      Route.stub(:find).and_return(Route.new)
      Route.stub(:params_for).and_return([])
      Route.stub(:comment_for).and_return([])

      get :show, :id => 1, :use_route => :api_taster

      assigns(:route).should be_kind_of(Route)
      assigns(:params).should be_kind_of(Array)
      assigns(:comment).should be_kind_of(Array)
    end

    it "#missing_definitions" do
      get :missing_definitions, :use_route => :api_taster

      assigns(:missing_definitions).should be_kind_of(Array)
    end

    it "#obsolete_definitions" do
      get :obsolete_definitions, :use_route => :api_taster

      assigns(:obsolete_definitions).should be_kind_of(Array)
    end

    context 'layout' do
      context 'when request is not XHR' do
        it 'renders application layout' do
          get :index, :use_route => :api_taster

          response.should render_template('api_taster/application')
        end
      end

      context 'when request is XHR' do
        before { request.stub(:xhr?) { true } }

        it 'does not render layout' do
          get :index, :use_route => :api_taster

          response.should_not render_template('api_taster/application')
        end
      end
    end
  end
end
