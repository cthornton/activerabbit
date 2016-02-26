ActiveRabbit
============

Easy to use workers for RabbitMQ + Ruby

**Work in progress**

## Getting Started
Define your exchanges:

```ruby
# config/rabbit/exchanges.rb
ActiveRabbit.configuration.exchanges.draw do
  topic :logs
  namespace :actions do
    direct :login
  end
end
```

Define your queues:

```ruby
# config/rabbit/queues.rb
ActiveRabbit.configuration.queues.draw do
  queue :log_queue, bind: :logs, routing_key: '*.critical', exclusive: true
end
```


Define your worker:

```ruby
# app/rabbit_consumers/log_queue_consumer.rb
class LogQueueConsumer < ActiveRabbit::Consumer

  def consume
    puts message
    puts message.body
  end
end
```

Publish to exchanges:

```ruby
message = 'Hello World!'
ActiveRabbit.publish('actions.login', message)
```
