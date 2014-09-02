module ApiTaster
  class Engine < ::Rails::Engine
    isolate_namespace ApiTaster

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end

    config.assets.precompile += %w( glyphicons-halflings.png glyphicons-halflings-white.png )

    silence_warnings do
      begin
        require 'pry'
        IRB = Pry
        rescue LoadError
      end
    end
  end
end
