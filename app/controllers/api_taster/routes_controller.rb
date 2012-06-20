module ApiTaster
  class RoutesController < ApplicationController
    def index
      @routes = Route.grouped_routes
    end

    def show
      @route  = Route.find(params[:id])
      @inputs = Route.inputs_for(@route)
    end
  end
end
