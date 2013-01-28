module ApiTaster
  class RoutesController < ApiTaster::ApplicationController
    before_filter :map_routes
    helper_method :missing_definitions?, :obsolete_definitions?

    def index
      @routes = Route.grouped_routes
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

    def missing_definitions?
      Route.missing_definitions.present? && ApiTaster.config.include_missing_definitions
    end

    def obsolete_definitions?
      Route.obsolete_definitions.present? && ApiTaster.config.include_obsolete_definitions
    end
  end
end
