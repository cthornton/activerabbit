require 'thor'

module ActiveRabbit
  class CLI < ::Thor
    desc 'consume WORKERS', 'Runs one or many workers'
    method_options require: :string
    def consume(workers)
      workers.split(',')
    end
  end
end
