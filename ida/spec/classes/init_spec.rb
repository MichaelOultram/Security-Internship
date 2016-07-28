require 'spec_helper'
describe 'ida' do

  context 'with defaults for all parameters' do
    it { should contain_class('ida') }
  end
end
