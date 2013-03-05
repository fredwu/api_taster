module ApiTaster
  class RouteCollector
    cattr_accessor :routes
    self.routes = []

    class << self
      def collect!(path)
        self.routes = []
        Dir["#{path}/**/*.rb"].each { |file| load(file) }
        Route.mappings = Proc.new do
          for route in RouteCollector.routes
              instance_eval(&route)
          end
        end
      end
    end
  end
end
