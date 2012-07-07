require "gelf"
require "graylog2-rails/initializers"
require "graylog2-rails/message"
require "graylog2-rails/middleware"
require "graylog2-rails/engine"
require "graylog2-rails/notifier"
require "graylog2-rails/version"

module Graylog2Rails
  mattr_accessor :gelf_config_options
end
