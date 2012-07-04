module Graylog2Rails
  class Message
    attr_accessor :args
    # The exception that caused this notice, if any
    attr_reader :exception

    # The backtrace from the given exception or hash.
    attr_reader :backtrace

    # The name of the class of error (such as RuntimeError)
    attr_reader :error_class

    # The name of the server environment (such as "production")
    attr_reader :environment_name

    # CGI variables such as HTTP_METHOD
    attr_reader :cgi_data

    # The message from the exception, or a general description of the error
    attr_reader :error_message

    # See Configuration#backtrace_filters
    attr_reader :backtrace_filters

    # See Configuration#params_filters
    attr_reader :params_filters

    # A hash of parameters from the query string or post body.
    attr_reader :parameters
    alias_method :params, :parameters

    # The component (if any) which was used in this request (usually the controller)
    attr_reader :component
    alias_method :controller, :component

    # The action (if any) that was called in this request
    attr_reader :action

    # A hash of session data from the request
    attr_reader :session_data

    # The path to the project that caused the error (usually Rails.root)
    attr_reader :project_root

    # The URL at which the error occurred (if any)
    attr_reader :url

    # The host name where this error occurred (if any)
    attr_reader :hostname

    attr_writer :exception, :backtrace, :error_class, :error_message,
      :backtrace_filters, :parameters,
      :environment_filters, :session_data, :url,
      :component, :action, :cgi_data, :environment_name, :hostname

    def initialize(args)
      self.args         = args
      self.exception    = args[:exception]
      self.url          = args[:url] || rack_env(:url)

      self.parameters   = args[:parameters] || action_dispatch_params || rack_env(:params) || {}
      self.component    = args[:component] || args[:controller] || parameters['controller']
      self.action       = args[:action] || parameters['action']

      self.environment_name = args[:environment_name]
      self.cgi_data         = args[:cgi_data] || args[:rack_env]
      self.backtrace        = self.exception.backtrace.join("\n")
      self.error_class      = exception_attribute(:error_class) {|exception| exception.class.name }
      self.error_message    = exception_attribute(:error_message, 'Notification') do |exception|
        "#{exception.class.name}: #{exception.message}"
      end
    end

    def message
      self.error_message
    end

    def rack_env(method)
      rack_request.send(method) if rack_request
    end

    def action_dispatch_params
      args[:rack_env]['action_dispatch.request.parameters'] if args[:rack_env]
    end

    def rack_request
      @rack_request ||= if args[:rack_env]
        ::Rack::Request.new(args[:rack_env])
      end
    end

    def exception_attribute(attribute, default = nil, &block)
      (exception && from_exception(attribute, &block)) || args[attribute] || default
    end

    def from_exception(attribute)
      if block_given?
        yield(exception)
      else
        exception.send(attribute)
      end
    end

    def find_session_data
      self.session_data = args[:session_data] || args[:session] || rack_session || {}
      self.session_data = session_data[:data] if session_data[:data]
    end

    def to_s
      message = []
      message << "=================== Git revision"
      message << `git log --pretty=format:'%H' -n 1`
      message << "=================== Exception Class"
      message << self.error_class
      message << "=================== Exception Message"
      message << self.error_message
      message << "=================== URL"
      message << self.url
      message << "=================== Parameters"
      message << args[:rack_env]['REQUEST_METHOD']
      message << self.parameters
      message << "=================== Component"
      message << self.component
      message << "=================== Action"
      message << self.action
      message << "=================== Ruby version"
      message << RUBY_VERSION
      message << "=================== Rails environment"
      message << Rails.env
      message << "=================== User information"
      message << args[:rack_env]['HTTP_USER_AGENT']
      message << args[:rack_env]['HTTP_ACCEPT_CHARSET']
      message << "=================== Backtrace"
      message << self.backtrace
      message << "=================== ARGS"
      message << self.args
      message.join("\n\n")
    end
  end # Notice
end
