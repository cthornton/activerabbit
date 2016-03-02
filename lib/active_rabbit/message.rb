require 'json'

module ActiveRabbit
  class Message
    attr_reader :delivery_info, :properties, :body

    def initialize(delivery_info, properties, body)
      @delivery_info = delivery_info
      @properties = properties
      @body = body
    end

    def params
      defined?(@params) ? @params : @params = calculate_params
    end

    def content_type
      properties[:content_type].to_s.downcase
    end

    def routing_key
      delivery_info[:routing_key]
    end

    protected

    # TODO: allow parsing of other param types
    def calculate_params
      content_type == 'application/json' ? JSON.parse(body) : nil
    end
  end
end
