require 'spec_helper'

describe ActiveRabbit::Configuration::Exchange do

  it 'supports a configuration block' do
    context = ActiveRabbit::Configuration::Exchange::ExchangeContext.new
    context.configure do
      direct 'top-level'
      namespace :my_namespace do
        direct 'nested'
      end
    end

    binding.pry

  end


end
