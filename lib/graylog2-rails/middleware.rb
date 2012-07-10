module Graylog2Rails
  class Middleware
    attr_reader :args

    def initialize(app, args = {})
      @app, @args = app, args
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      begin
        @app.call(env)
      rescue Exception => err
        send_to_graylog2(err, env)
        raise
      end
    end

    def send_to_graylog2 err, env
      opts = {:rack_env => env}
      begin
        opts = opts.merge(:exception => err) if err.is_a?(Exception)
        opts = opts.merge(err.to_hash) if err.respond_to?(:to_hash)
        notice = Graylog2Rails::Message.new(opts)
        args = {
          :short_message => notice.message,
          :full_message => notice.to_s,
          :facility => @args.delete("facility") + "_exception",
          :level => @args.delete("level"),
          :host => @args.delete("local_app_name"),
          :file => err.backtrace[0].split(":")[0],
          :line => err.backtrace[0].split(":")[1],
        }

        Rails.logger.info "[GRAYLOG] [#{Time.now.utc.to_datetime}] #{args.inspect}"

        unless Rails.env.development? || Rails.env.test?
          notifier = GELF::Notifier.new(@args.delete("hostname"), @args.delete("port"), @args.delete("max_chunk_size"))
          notifier.notify!(args)
        end
      rescue => i_err
        puts "Graylog2 Exception logger. Could not send message: " + i_err.message
        puts i_err.backtrace.join("\n")
      end
    end
  end # class Middleware
end
