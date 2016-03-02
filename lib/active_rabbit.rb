require 'bunny'
require 'active_rabbit/version'

module ActiveRabbit
  autoload :Bundle,        'active_rabbit/bundle'
  autoload :Configuration, 'active_rabbit/configuration'
  autoload :Consumer,      'active_rabbit/consumer'
  autoload :Message,       'active_rabbit/message'
  autoload :Util,          'active_rabbit/util'

  def self.version
    VERSION
  end

  def self.configuration
    @default_bundle ||= Bundle.new
  end

  def self.load_config_directory(directory_path)
    configuration.load_directory(directory_path)
  end

  def self.temporarily_taint_configuration(bundle)
    raise ArgumentError, 'No block given' unless block_given?
    original_bundle = configuration
    @default_bundle = bundle
    yield
  ensure
    @default_bundle = original_bundle
  end
end
