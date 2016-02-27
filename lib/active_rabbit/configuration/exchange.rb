module ActiveRabbit::Configuration
  module Exchange
    class ExchangeContext < Context
      def exchange(name, type, options = {})
        # TODO: allow overriding name outside of convention
        add_config_value(name, Value.new(qualify_name(name), type.to_sym, effective_options(options)))
      end

      def direct(name, options = {})
        exchange(name, :direct, options)
      end

      def topic(name, options = {})
        exchange(name, :topic, options)
      end
    end

    # Maps to a Bunny::Exchange
    class Value < Struct.new(:name, :type, :options)
      def to_exchange(bundle)
        Bunny::Exchange.new(
            bundle.get_channel(options.fetch(:session)),
            type, name, options)
      end
    end
  end
end
