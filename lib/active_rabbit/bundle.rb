require 'thread'

module ActiveRabbit

  # A giant blob of configuration objects into a single package
  class Bundle
    LOAD_DIRECTORY_MUTEX = Mutex.new

    # @return [SessionLoader]
    attr_accessor :session_loader

    # @return [Exchange::ExchangeContext]
    attr_accessor :exchange_context

    # @return [Queue::QueueContext]
    attr_accessor :queue_context

    attr_reader :loaded_sessions

    attr_accessor :environment

    alias_method :exchanges, :exchange_context
    alias_method :queues, :queue_context

    def initialize(environment: nil)
      @exchange_context = Exchange::ExchangeContext.new
      @queue_context = Queue::QueueContext.new
      @session_loader = SessionLoader.new
      @loaded_sessions = {}
      @environment = environment || ENV['ACTIVERABBIT_ENV'] || 'development'
    end

    def load_directory(directory_path)
      LOAD_DIRECTORY_MUTEX.synchronize do
        ActiveRabbit.temporarily_taint_configuration(self) do
          glob = File.join(directory_path, '**', '*.rb')
          Dir[glob].each do |file|
            require File.expand_path(file)
          end

          config_file = File.join(directory_path, 'sessions.yml')
          if File.exist?(config_file)
            session_loader.load_yaml_file!(config_file, environment)
          end
        end
      end
    end

    def get_session(name)
      loaded_sessions[name] ||= session_loader.to_session(name).tap do |session|
        session.start
      end
    end

    def get_channel(name, thread = Thread.current)
      thread["activerabbit_bundle_#{name}"] ||= get_session(name).create_channel
    end

    def get_exchange(qualified_name)
      exchange_value = exchange_context.search_values!(qualified_name)
      exchange_value.to_exchange(self)
    end

    def get_and_bind_queue(qualified_name)
      queue_value = queue_context.search_values!(qualified_name)
      queue_value.get_and_bind_queue(self)
    end

    def publish(qualified_name, message, publish_options = {})
      get_exchange(qualified_name).publish(message, publish_options)
    end
  end
end
