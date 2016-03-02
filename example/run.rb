require 'bundler/setup'
require 'pry'
require 'awesome_print'
require 'activerabbit'

ActiveRabbit.load_config_directory('example/rabbit')
config = ActiveRabbit.configuration
x = config.get_exchange(:direct)
x.publish("I am a notification", routing_key: 'notifications')
x.publish('I am a log', routing_key: 'logs')

class FakeConsumer < ActiveRabbit::Consumer
  bind :notifications, to: :notification_action
  bind :logs, to: :log_action

  def notification_action
    binding.pry
  end

  def log_action
    binding.pry
  end
end

runner = ActiveRabbit::Runner.new(ActiveRabbit.configuration, FakeConsumer)

runner.run!.wait!
