require 'spec_helper'
describe 'bufferOverflow' do

  context 'with defaults for all parameters' do
    it { should contain_class('bufferOverflow') }
  end
end
