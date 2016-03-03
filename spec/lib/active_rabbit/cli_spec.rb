require 'spec_helper'

RSpec.describe ActiveRabbit::CLI do
  subject(:cli) { described_class.new }

  let(:options) { {} }

  before { cli.options = options }

  describe '#consume' do
    subject { cli.consume(arguments) }

    let(:arguments) { 'SomeWorker,AnotherWorker' }

    it 'foos' do
      expect(true).to eq(true)
    end
  end
end
