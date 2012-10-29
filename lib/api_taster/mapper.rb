module ApiTaster
  class Mapper
    cattr_accessor :last_desc

    class << self
      def get(path, params = {}, metadata = {})
        map_method(:get, path, params, metadata)
      end

      def post(path, params = {}, metadata = {})
        map_method(:post, path, params, metadata)
      end

      def put(path, params = {}, metadata = {})
        map_method(:put, path, params, metadata)
      end

      def patch(path, params = {}, metadata = {})
        map_method(:patch, path, params, metadata)
      end

      def delete(path, params = {}, metadata = {})
        map_method(:delete, path, params, metadata)
      end

      def desc(text)
        self.last_desc = text
      end

      private

      def map_method(method, path, params, metadata)
        route = Route.find_by_verb_and_path(method, path)

        if route.nil?
          Route.obsolete_definitions << {
            :verb   => method,
            :path   => path,
            :params => params
          }
        else
          Route.supplied_params[route[:id]] ||= []
          Route.supplied_params[route[:id]] << ApiTaster.global_params.merge(params)

          unless last_desc.nil?
            Route.comments[route[:id]] = last_desc
            self.last_desc = nil
          end

          if metadata.any?
            Route.metadata[route[:id]] = metadata
          end
        end
      end
    end
  end
end
