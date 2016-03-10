require 'spec_helper'

RSpec.describe ActiveRabbit::Configuration::Context do
  subject(:context) { described_class.new }

  let(:level1) { context.child_contexes['level1'] }
  let(:level2) { level1.child_contexes['level2'] }

  # Example DSL
  before do
    context.configure do
      add_config_value :item, 'root-value'
      namespace :level1 do
        defaults option_a: 'apple', option_b: 'bananna'
        add_config_value :item, 'level2-value'
        namespace 'level2', option_d: 'donut' do
          defaults option_b: 'bonzai', option_c: 'carrot'
          add_config_value 'some-item', 'level2-value'
        end
      end
    end
  end

  describe 'namespacing' do
    it 'namespaces correctly' do
      expect(context.child_contexes['level1']).to_not be_nil
      expect(level1.child_contexes['level2']).to_not be_nil
    end
  end

  describe '#search_values' do
    it 'works' do
      expect(context.search_values('item')).to eq('root-value')
      expect(context.search_values('does-not-exist')).to be_nil
      expect(context.search_values('level1')).to be_nil
      expect(context.search_values('level1.item')).to eq('level2-value')
      expect(context.search_values('level1.level2')).to be_nil
    end
  end


end
