module ActiveRabbit::Configuration
  class Bundle
    attr_accessor :sessions
    attr_accessor :exchange_context
    attr_accessor :queue_contexes

    alias_method :exchanges, :exchange_context

    def initialize
      @exchange_contex = ExchangeContext.new
    end
  end
end
