require 'spec_helper'
describe 'gentoken' do

  context 'with defaults for all parameters' do
    it { should contain_class('gentoken') }
  end
end
