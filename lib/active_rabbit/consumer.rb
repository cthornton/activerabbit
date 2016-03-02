module ActiveRabbit
  class Consumer
    class Binding < Struct.new(:queue_name, :method_name)
    end

    class << self
      def bind(*queue_names, to:)
        bindings.concat(queue_names.map do |queue_name|
          Binding.new(queue_name, to)
        end.to_a)
      end

      def bindings
        @bindings ||= []
      end

      def process_message!(channel, method, message)
        self.new(channel, message).send(method)
      end
    end

    attr_reader :message, :_channel

    def initialize(channel, message)
      @message = message
      @_channel = channel
    end

    def ack!(multiple = false)
      _channel.acknowledge(message.delivery_info.delivery_tag, multiple)
    end

    def params
      message.params
    end


  end
end
