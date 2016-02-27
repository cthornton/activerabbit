require 'bundler/setup'
require 'pry'
require 'awesome_print'
require 'activerabbit'

ActiveRabbit.load_config_directory('example/rabbit')
config = ActiveRabbit.configuration
x = config.get_exchange(:direct)
q = config.get_and_bind_queue(:notifications)
x.publish("foo!", routing_key: 'notifications')
