require 'bunny'
require 'active_rabbit/version'

module ActiveRabbit
  autoload :Configuration, 'active_rabbit/configuration'

  def self.version
    VERSION
  end

  def self.configuration
    @default_bundle ||= Configuration::Bundle.new
  end

  def self.load_config_directory(directory_path)
    glob = File.join(directory_path, '**', '*.rb')
    Dir[glob].each do |file|
      require file
    end
  end
end
