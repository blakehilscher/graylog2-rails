require "gelf"
require "graylog2-rails/message"
require "graylog2-rails/middleware"
require "graylog2-rails/notifier"
require "graylog2-rails/version"

module Graylog2Rails
  
  def self.configuration
    # cached?
    return @@configuration if defined?(@@configuration)
    # read
    custom_config_file = Rails.root.join("config", "graylog2_rails.yml") if Rails.root.present?
    if custom_config_file && custom_config_file.exist?
      file_content = File.open(custom_config_file).read
    else
      puts "WARNING: Graylog2 config not found. Using default configuration options. Please run `rake graylog2_rails:install'"
      file_content = File.open(File.expand_path(File.join("..", "..", "config", "graylog2_rails.yml"), __FILE__)).read
    end
    @@configuration = YAML.load(ERB.new(file_content).result)[Rails.env]
    @@configuration
  end
  
end
