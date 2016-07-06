require 'spec_helper'
describe 'jdgui' do

  context 'with defaults for all parameters' do
    it { should contain_class('jdgui') }
  end
end
