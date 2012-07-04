module Graylog2Rails
  module Initializers
    def read_config!
      custom_config_file = Rails.root.join("config", "graylog2_rails.yml")
      file_content = if custom_config_file.exist?
                       File.open(custom_config_file).read
                     else
                       puts "WARNING: Graylog2 config not found. Using default configuration options. Please run `rake graylog2_rails:install'"
                       File.open(File.expand_path(File.join("..", "..", "..", "config", "graylog2_rails.yml"), __FILE__)).read
                     end
      Graylog2Rails.gelf_config_options = YAML.load(ERB.new(file_content).result)[Rails.env]
    end
  end
end
