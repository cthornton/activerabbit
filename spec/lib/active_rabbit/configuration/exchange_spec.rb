require 'spec_helper'

describe ActiveRabbit::Configuration::Exchange::ExchangeContext do
  subject(:exchange) { described_class.new }

  describe '#exchange' do
    it 'adds an exchange to config values' do
      exchange.exchange(:my_topic, :topic, some: :options)
      value = exchange.search(:my_topic)

      expected = {
        name: 'my-topic',
        type: :topic,
        options: {
          some: :options,
          session: :default
        }
      }
      expect(value.to_h).to eql(expected)
    end
  end

  describe '#direct' do
    it 'is similar to #exchange, and sets the exchange as direct' do
      exchange.direct(:my_direct)
      expected = {
        name: 'my-direct',
        type: :direct,
        options: {
          session: :default
        }
      }

      expect(exchange.search(:my_direct).to_h).to eq(expected)
    end
  end

  describe '#topic' do
    it 'is similar to #exchange, and sets the exchange as topic' do
      exchange.topic(:my_topic)
      expected = {
        name: 'my-topic',
        type: :topic,
        options: {
          session: :default
        }
      }

      expect(exchange.search('my-topic').to_h).to eq(expected)
    end
  end
end
