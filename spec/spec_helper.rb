require 'active_rabbit'
require 'pry'
require 'awesome_print'

# Set up logger so we don't pollute test STDOUT
log_file = File.join('spec/logs/test.log')
File.unlink(log_file) if File.exist?(log_file)
ActiveRabbit.logger = Logger.new(log_file)
