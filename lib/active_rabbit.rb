require 'bunny'
require 'active_rabbit/version'

module ActiveRabbit
  autoload :Configuration, 'active_rabbit/configuration'
  autoload :Util,          'active_rabbit/util'

  def self.version
    VERSION
  end

  def self.configuration
    @default_bundle ||= Configuration::Bundle.new
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
