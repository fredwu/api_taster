module ApiTaster
  class RoutesController < ApplicationController
    def index
      @routes = Route.grouped_routes
      @has_missing_definitions  = Route.missing_definitions.present?
      @has_obsolete_definitions = Route.obsolete_definitions.present?
    end

    def show
      @route  = Route.find(params[:id])
      @inputs = Route.inputs_for(@route)
    end

    def missing_definitions
      @missing_definitions = Route.missing_definitions
    end

    def obsolete_definitions
      @obsolete_definitions = Route.obsolete_definitions
    end
  end
end
