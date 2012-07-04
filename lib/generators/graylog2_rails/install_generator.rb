require "rails/generators"
require "rake"

module Graylog2Rails
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Graylog2Rails install generator"
    def install
      say "Install Graylog2Rails", :green
      @app_name = Rails.application.class.name.sub(/::Application$/, "").underscore
      say "Copying config file"
      template "config.erb", "config/graylog2_rails.yml"
      say "Done", :green
    end
  end
end
