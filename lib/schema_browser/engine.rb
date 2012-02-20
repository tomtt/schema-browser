module SchemaBrowser
  if defined?(Rails::Engine)
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
    end
  end
end
