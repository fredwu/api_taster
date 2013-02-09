class ParseableRoute

  delegate :name, :path, :requirements, :to => :route

  def initialize(route)
    @route = route
    @rack_app = ParseableRoute.discover_rack_app(@route.app)
  end

  def normalisable?
    return false if @route.app.is_a?(ActionDispatch::Routing::Mapper::Constraints)
    return false if @route.app.is_a?(Sprockets::Environment)
    return false if @route.app == ApiTaster::Engine
    return false if @route.verb.is_a?(Regexp) && @route.verb == //
    return false if @route.verb.is_a?(String) && @route.verb.empty?
    true
  end

  def rack_routes
    @rack_app.routes.routes
  rescue
    []
  end

  def verbs
    case @route.verb
    when String
      @route.verb.split('|')
    when Regexp
      @route.verb.source.split('|')
    end
  end

  def self.discover_rack_app(app)
    class_name = app.class.name
    if class_name == "ActionDispatch::Routing::Mapper::Constraints"
      discover_rack_app(app.app)
    elsif class_name !~ /^ActionDispatch::Routing/
      app
    end
  end

  private

  def route
    @route
  end



end