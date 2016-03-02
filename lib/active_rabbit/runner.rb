require 'set'

module ActiveRabbit
  class Runner
    include Loggable

    attr_reader :bundle

    attr_reader :consumer_klasses

    attr_reader :bunny_consumers

    def initialize(bundle, consumer_klasses)
      @bundle = bundle
      @consumer_klasses = Util.array_wrap(consumer_klasses)
      @bunny_consumers = []
    end

    def run!
      consumer_klasses.each do |klass|
        run_consumer_klass(klass)
      end
      self
    end

    def wait!
      logger.info 'Joining worker threads. INTERRUPT or Ctrl-C to exit'
      joined = Set.new
      bunny_consumers.each do |bunny_consumer|
        channel = bunny_consumer.channel
        next if joined.include?(channel)
        joined << channel
        channel.work_pool.join
      end
    rescue Interrupt => _
      puts 'Exiting...'
    end

    protected

    def run_consumer_klass(klass)
      unless klass.bindings.any?
        logger.warn "Consumer #{klass.name} does not bind to any queues; ignoring"
        return
      end

      klass.bindings.each do |binding|
        run_binding(klass, binding)
      end
    end

    def run_binding(consumer_klass, binding)
      unless consumer_klass.instance_methods(false).include?(binding.method_name)
        raise "#{consumer_klass.name} does not define a method #{binding.method_name}"
      end

      queue_value = bundle.queue_context.search_values!(binding.queue_name)
      queue = bundle.get_and_bind_queue(binding.queue_name)
      bunny_consumer = queue.subscribe do |delivery_info,properties,body|
        message = ActiveRabbit::Message.new(delivery_info, properties, body)
        consumer_klass.process_message!(queue.channel, binding.method_name, message)
      end
      logger.info "Bound #{consumer_klass.name}##{binding.method_name} to queue '#{queue_value.queue_name}' (rabbitmq name: #{queue.name})"
      @bunny_consumers << bunny_consumer
    end

  end
end
