require 'bunny'
require 'active_rabbit/version'
require 'logger'

module ActiveRabbit
  autoload :Bundle,        'active_rabbit/bundle'
  autoload :Configuration, 'active_rabbit/configuration'
  autoload :Consumer,      'active_rabbit/consumer'
  autoload :Loggable,      'active_rabbit/loggable'
  autoload :Message,       'active_rabbit/message'
  autoload :Runner,        'active_rabbit/runner'
  autoload :Util,          'active_rabbit/util'

  class << self
    attr_writer :logger

    def version
      VERSION
    end

    def logger
      @logger = Logger.new(STDOUT)
    end

    def configuration
      @default_bundle ||= Bundle.new
    end

    def load_config_directory(directory_path)
      configuration.load_directory(directory_path)
    end

    def temporarily_taint_configuration(bundle)
      raise ArgumentError, 'No block given' unless block_given?
      original_bundle = configuration
      @default_bundle = bundle
      yield
    ensure
      @default_bundle = original_bundle
    end
  end
end
