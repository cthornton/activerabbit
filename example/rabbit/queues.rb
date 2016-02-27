ActiveRabbit.configuration.queues.draw do
  queue :notifications, bind: :direct
end
