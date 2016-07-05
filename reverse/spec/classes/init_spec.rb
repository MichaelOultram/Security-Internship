require 'spec_helper'
describe 'reverse' do

  context 'with defaults for all parameters' do
    it { should contain_class('reverse') }
  end
end
