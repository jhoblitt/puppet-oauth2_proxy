require 'spec_helper'

describe 'oauth2_proxy', :type => :class do

  describe 'for osfamily RedHat' do
    it { should contain_class('oauth2_proxy') }
  end

end
