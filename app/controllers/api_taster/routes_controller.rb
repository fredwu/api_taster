module ApiTaster
  class RoutesController < ApplicationController
    def index
      @routes = Route.grouped_routes
      @has_obsolete_definitions = Route.obsolete_definitions.size > 0
    end

    def show
      @route  = Route.find(params[:id])
      @inputs = Route.inputs_for(@route)
    end

    def obsolete_definitions
      @obsolete_definitions = Route.obsolete_definitions
    end
  end
end
