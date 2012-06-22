module ApiTaster
  class Route
    cattr_accessor :route_set
    cattr_accessor :routes
    cattr_accessor :mappings
    cattr_accessor :inputs
    cattr_accessor :obsolete_definitions

    class << self
      def map_routes
        self.route_set            = Rails.application.routes
        self.inputs               = {}
        self.obsolete_definitions = []

        normalise_routes!

        Mapper.instance_eval(&self.mappings.call)
      end

      def normalise_routes!
        self.routes = []
        i = -1

        unless route_set.respond_to?(:routes)
          raise ApiTaster::Exception.new('Route definitions are missing, have you defined ApiTaster.routes?')
        end

        route_set.routes.each do |route|
          next if route.app.is_a?(Sprockets::Environment)
          next if route.app == ApiTaster::Engine

          if (rack_app = discover_rack_app(route.app)) && rack_app.respond_to?(:routes)
            rack_app.routes.routes.each do |rack_route|
              self.routes << normalise_route(rack_route, i+=1)
            end
          end

          next if route.verb.source.empty?

          self.routes << normalise_route(route, i+=1)
        end
      end

      def grouped_routes
        routes.group_by { |r| r[:reqs][:controller] }
      end

      def find(id)
        routes.select { |r| r[:id] == id.to_i }[0]
      end

      def find_by_verb_and_path(verb, path)
        routes.select do |r|
          r[:path].to_s == path &&
          r[:verb].to_s.downcase == verb.to_s.downcase
        end[0]
      end

      def inputs_for(route)
        unless inputs.has_key?(route[:id])
          return { :undefined => route }
        end

        inputs[route[:id]].collect { |input| split_input(input, route) }
      end

      def missing_definitions
        routes.select { |route| undefined_route?(route) }
      end

      private

      def undefined_route?(route)
        r = inputs_for(route)
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

      def normalise_route(route, id)
        {
          :id   => id,
          :name => route.name,
          :verb => route.verb.source.gsub(/[$^]/, ''),
          :path => route.path.spec.to_s.sub('(.:format)', ''),
          :reqs => route.requirements
        }
      end

      def split_input(input, route)
        url_param_keys = route[:path].scan /:\w+/

        url_params  = input.select { |k| ":#{k}".in?(url_param_keys) }
        post_params = input.diff(url_params)

        {
          :url_params  => url_params,
          :post_params => post_params
        }
      end
    end
  end
end
