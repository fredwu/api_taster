module ApiTaster
  class Route
    cattr_accessor :route_set
    cattr_accessor :inputs

    class << self
      def routes
        _routes = []

        route_set.routes.each_with_index do |route, index|
          next if route.verb.source.empty?

          _routes << {
            :id   => index,
            :name => route.name,
            :verb => route.verb.source.gsub(/[$^]/, ''),
            :path => route.path.spec.to_s.sub('(.:format)', ''),
            :reqs => route.requirements
          }
        end

        _routes
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

      private

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
