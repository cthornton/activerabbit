require 'thor'

module ActiveRabbit
  class CLI < ::Thor
    include Loggable

    desc 'consume WORKERS', 'Runs one or many workers'
    method_options require: :string, config_directory: :string
    def consume(workers)
      load_require(options[:require])
      load_config_directory(options[:config_directory])
      klasses = workers.split(',').map do |string_constant_name|
        convert_to_class(string_constant_name)
      end
      runner = ActiveRabbit::Runner.new(ActiveRabbit.configuration, klasses)
      runner.run!
      runner.wait!
      runner
    end

    protected

    def load_config_directory(config_directory)
      if config_directory.nil? || config_directory.empty?
        logger.warn 'No --config-directory specified!'
        return
      end
      ActiveRabbit.load_config_directory(config_directory)
    end

    def load_require(require_file)
      return if require_file.nil?
      require require_file
    end

    def convert_to_class(string_constant_name)
      klass = Util.string_constantize(string_constant_name)
      unless klass < ActiveRabbit::Consumer
        raise "class #{klass.name} must extend from ActiveRabbit::Consumer"
      end
      klass
    end
  end
end
