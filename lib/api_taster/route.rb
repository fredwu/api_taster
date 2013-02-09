require File.expand_path('../parseable_route', __FILE__)

module ApiTaster
  class Route
    cattr_accessor :route_set
    cattr_accessor :routes
    cattr_accessor :mappings
    cattr_accessor :supplied_params
    cattr_accessor :obsolete_definitions
    cattr_accessor :comments
    cattr_accessor :metadata

    class << self

      def map_routes
        self.route_set            = Rails.application.routes
        self.supplied_params      = {}
        self.obsolete_definitions = []
        self.comments             = {}
        self.metadata             = {}

        normalise_routes!

        begin
          Mapper.instance_eval(&self.mappings.call)
        rescue
          Route.mappings = {}
        end
      end

      def normalise_routes!
        @_route_counter = 0
        self.routes = []

        unless route_set.respond_to?(:routes)
          raise ApiTaster::Exception.new('Route definitions are missing, have you defined ApiTaster.routes?')
        end

        route_set.routes.map { |r| ParseableRoute.new(r) }.each do |route|
          route.rack_routes.map { |rr| ParseableRoute.new(rr) }.each do |rack_route|
            self.routes << normalise_route(rack_route, route.sanitized_path)
          end

          self.routes << normalise_route(route) if route.normalisable?
        end

        self.routes.flatten!
      end

      def grouped_routes
        defined_definitions.group_by { |r| r[:reqs][:controller] }
      end

      def find(id)
        routes.find { |r| r[:id] == id.to_i }
      end

      def find_by_verb_and_path(verb, path)
        routes.find do |r|
          r[:path].to_s == path &&
          r[:verb].to_s.downcase == verb.to_s.downcase
        end
      end

      def params_for(route)
        unless supplied_params.has_key?(route[:id])
          return { :undefined => route }
        end

        supplied_params[route[:id]].collect { |input| split_input(input, route) }
      end

      def comment_for(route)
        unless undefined_route?(route)
          self.comments[route[:id].to_i]
        end
      end

      def metadata_for(route)
        unless undefined_route?(route)
          self.metadata[route[:id].to_i]
        end
      end

      def defined_definitions
        routes.reject { |route| undefined_route?(route) }
      end

      def missing_definitions
        routes.select { |route| undefined_route?(route) }
      end

      private

      def undefined_route?(route)
        r = params_for(route)
        r.is_a?(Hash) && r.has_key?(:undefined)
      end

      def normalise_route(route, path_prefix = nil)
        route.verbs.map do |verb|
          {
            :id   => @_route_counter+=1,
            :name => route.name,
            :verb => verb,
            :path => path_prefix.to_s + route.sanitized_path,
            :reqs => route.requirements
          }
        end
      end

      def split_input(input, route)
        url_param_keys = route[:path].scan /:\w+/

        url_params  = input.reject { |k, v| ! ":#{k}".in?(url_param_keys) }
        post_params = input.diff(url_params)

        {
          :url_params  => url_params,
          :post_params => post_params
        }
      end
    end
  end
end
