module Graylog2Rails
  class Notifier
    attr_reader :gelf

    def initialize(args = {})
      @gelf = GELF::Notifier.new(Graylog2Rails.configuration["host"],
                                 Graylog2Rails.configuration["port"],
                                 Graylog2Rails.configuration["max_chunk_size"], {
                                   :facility => Graylog2Rails.configuration["facility"],
                                   :level => args.has_key?("level") ? args["level"] : Graylog2Rails.configuration["level"],
                                   :host => Graylog2Rails.configuration["local_app_name"]
                                 })
    end

    def self.notify! args
      @notifier ||= new args
      timestamp = Time.now.utc
      args.merge!({:timestamp => timestamp.to_f})

      Rails.logger.info "[GRAYLOG] [#{timestamp.to_datetime}] #{args.inspect}"

      @notifier.gelf.notify! args unless Rails.env.development? || Rails.env.test?
    end

  end
end
