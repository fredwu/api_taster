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
      def map_routes(path = ApiTaster.route_path)
        self.route_set            = Rails.application.routes
        self.supplied_params      = {}
        self.obsolete_definitions = []
        self.comments             = {}
        self.metadata             = {}

        normalise_routes!

        begin
          ApiTaster::RouteCollector.collect(path)
          Mapper.instance_eval(&self.mappings)
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

        route_set.routes.each do |route|
          next if route.app.is_a?(Sprockets::Environment)
          next if route.app == ApiTaster::Engine
          next if route.defaults[:controller].to_s.starts_with?('rails/')

          rack_app = discover_rack_app(route.app)

          if rack_app && rack_app.respond_to?(:routes) && rack_app.routes.respond_to?(:routes)
            rack_app.routes.routes.each do |rack_route|
              self.routes << normalise_route(rack_route, route.path.spec)
            end
          end

          next if route.verb.source.empty?

          self.routes << normalise_route(route)
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

      def discover_rack_app(app)
        class_name = app.class.name.to_s
        if class_name == "ActionDispatch::Routing::Mapper::Constraints"
          discover_rack_app(app.app)
        elsif class_name !~ /^ActionDispatch::Routing/
          app
        end
      end

      def normalise_route(route, path_prefix = nil)
        route.verb.source.split('|').map do |verb|
          path = path_prefix.to_s + route.path.spec.to_s.sub('(.:format)', '')
          {
            :id        => @_route_counter+=1,
            :name      => route.name,
            :verb      => verb.gsub(/[$^]/, ''),
            :path      => path,
            :full_path => rails_url_root + path,
            :reqs      => route.requirements
          }
        end
      end

      def split_input(input, route)
        url_param_keys = route[:path].scan /:\w+/

        url_params  = input.reject { |k, v| ! ":#{k}".in?(url_param_keys) }
        post_params = hash_diff(input, url_params)

        {
          :url_params  => url_params,
          :post_params => post_params
        }
      end

      def hash_diff(h1, h2)
        h1.dup.delete_if do |k, v|
          h2[k] == v
        end.merge!(h2.dup.delete_if { |k, v| h1.has_key?(k) })
      end

      def rails_url_root
        ActionController::Base.relative_url_root.to_s.chomp('/')
      end
    end
  end
end
