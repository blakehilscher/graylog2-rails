if defined?(Rails) && Rails.version.to_f >= 3.0
  class Engine < ::Rails::Engine
    if Rails.version.to_f > 3.1
      isolate_namespace Graylog2Rails
    end
    include Graylog2Rails::Initializers

    initializer "graylog2_rails.establish_connection" do |app|
      read_config!
    end

    initializer "graylog2_rails.add_middleware", :after => "graylog2_rails.establish_connection" do |app|
      app.middleware.insert_after ActionDispatch::Head, Graylog2Rails::Middleware, Graylog2Rails.gelf_config_options
    end
  end
end
