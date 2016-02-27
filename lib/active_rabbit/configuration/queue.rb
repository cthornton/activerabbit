module ActiveRabbit::Configuration
  module Queue
    class QueueContext < Context
      def queue(name, options = {})
        options = {routing_key: name.to_s}.merge(options.dup)
        queue_name = options.delete(:name) || qualify_name(name)
        value = Value.new(queue_name, effective_options(options))
        add_config_value(name, value)
      end

      def durable(name, options = {})
        queue(name, options.merge(durable: true))
      end

      def temporary(name, options = {})
        queue(name, options.merge(exclusive: true, name: ''))
      end
    end

    class Value < Struct.new(:queue_name, :options)
      QUEUE_ONLY_KEYS = [:durable, :auto_delete, :exclusive, :arguments]

      def qualified_exchange_name
        @qualified_exchange_name ||= (options[:bind] || options[:exchange] || options[:x]).to_s
      end

      def routing_key
        options[:routing_key]
      end

      def queue_only_options
        ActiveRabbit::Util.hash_only_keys(options, *QUEUE_ONLY_KEYS)
      end

      def bind_only_options
        ActiveRabbit::Util.hash_except_keys(options, *QUEUE_ONLY_KEYS)
      end

      def to_queue(bundle)
        get_channel(bundle).queue(queue_name, queue_only_options)
      end

      def get_channel(bundle)
        bundle.get_channel(options.fetch(:session))
      end

      def bind(queue, exchange)
        queue.bind(exchange, bind_only_options)
      end

      def get_exchange(bundle)
        if qualified_exchange_name.nil?
          raise ArgumentError, 'No exchange name set; ensure in your exchange definition your queue is bound to an exchange'
        end

        exchange_value = bundle.exchange_context.search_values(qualified_exchange_name)

        if exchange_value.nil?
          raise ArgumentError, "Unknown exchange name '#{qualified_exchange_name}'; perhaps it is not defined?"
        end

        if exchange_value.options[:session] != options[:session]
          raise ArgumentError, "Queue session does not match binded queue's session"
        end

        exchange_value.to_exchange(bundle)
      end

      def get_and_bind_queue(bundle)
        queue = to_queue(bundle)
        exchange = get_exchange(bundle)
        bind(queue, exchange)
        queue
      end
    end
  end
end
