require 'spec_helper'

class SomeWorker < ActiveRabbit::Consumer
end

RSpec.describe ActiveRabbit::CLI do
  subject(:cli) { described_class.new }

  let(:options) { {} }

  before { cli.options = options }

  describe '#consume' do
    subject { cli.consume(arguments) }

    let(:arguments) { 'SomeWorker' }

    it 'works with valid workers' do
      expect_any_instance_of(ActiveRabbit::Runner).to receive(:run!)
      expect_any_instance_of(ActiveRabbit::Runner).to receive(:wait!).and_return(nil)

      expect(subject.consumer_klasses).to contain_exactly(SomeWorker)
    end

    context 'with an invalid class' do
      let(:arguments) { 'SomeWorker,BadWorker' }

      it 'raises an error' do
        expect { subject }.to raise_error(NameError, 'uninitialized constant BadWorker')
      end
    end

    context 'with --config-directory' do
      let(:options) { { config_directory: 'spec/example/rabbit'} }

      it 'includes the directory' do
        expect { subject }.to change { ActiveRabbit.configuration.queues.config_values.length }
      end
    end
  end
end
