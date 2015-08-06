require 'spec_helper_acceptance'

describe 'oauth2_proxy class' do
  describe 'running puppet code' do
    pp = <<-EOS
      if $::osfamily == 'RedHat' {
        class { 'epel': } -> Class['oauth2_proxy']
      }

      include ::oauth2_proxy
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
