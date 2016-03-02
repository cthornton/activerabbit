module ActiveRabbit
  class Consumer
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

    def self.process_message!(channel, method, message)
      self.new(channel, message).send(method)
    end
  end
end
