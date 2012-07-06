module Graylog2Rails
  class Notifier
    attr_reader :gelf

    def initialize(args = {})
      @gelf = GELF::Notifier.new(Graylog2Rails.gelf_config_options["host"],
                                 Graylog2Rails.gelf_config_options["port"],
                                 Graylog2Rails.gelf_config_options["max_chunk_size"], {
                                   facility: Graylog2Rails.gelf_config_options["facility"],
                                   level: args.has_key?("level") ? args["level"] : Graylog2Rails.gelf_config_options["level"],
                                   host: Graylog2Rails.gelf_config_options["local_app_name"]
                                 })
    end

    def self.notify! args
      @notifier ||= new args
      timestamp = Time.now.utc
      Rails.logger.tagged("GRAYLOG") do
        Rails.logger.info "[#{timestamp.to_datetime}] #{args.inspect}"
      end
      args.merge!({timestamp: timestamp.to_f})
      @notifier.gelf.notify! args unless Rails.env.development?
    end

  end
end
