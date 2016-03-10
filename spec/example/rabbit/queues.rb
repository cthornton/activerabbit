ActiveRabbit.configuration.queues.draw do
  queue :notifications, bind: :direct
  queue :logs, bind: :direct
end
