module ActiveRabbit
  module Loggable
    def logger
      ActiveRabbit.logger
    end

    def self.included(base)
      base.extend Loggable
    end
  end
end
