module ApiTaster
  class RoutesController < ApiTaster::ApplicationController
    before_filter :map_routes
    layout false, except: :index

    def index
      @routes = Route.grouped_routes
      @has_missing_definitions  = Route.missing_definitions.present?
      @has_obsolete_definitions = Route.obsolete_definitions.present?
    end

    def show
      @route   = Route.find(params[:id])
      @params  = Route.params_for(@route)
      @comment = Route.comment_for(@route)
    end

    def missing_definitions
      @missing_definitions = Route.missing_definitions
    end

    def obsolete_definitions
      @obsolete_definitions = Route.obsolete_definitions
    end

    private

    def map_routes
      Route.map_routes
    end
  end
end
