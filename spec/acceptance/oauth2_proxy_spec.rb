require 'spec_helper_acceptance'

describe 'oauth2_proxy class', :order => :defined do
  describe 'running puppet code' do
    pp = <<-EOS
      include ::oauth2_proxy

      ::oauth2_proxy::instance { 'proxy1':
        config => {
          http_address      => '127.0.0.1:4180',
          client_id         => '1234',
          client_secret     => 'abcd',
          github_org        => 'foo',
          upstreams         => [ 'http://127.0.0.1:3000' ],
          cookie_secret     => '1234',
          pass_access_token => false,
          pass_host_header  => true,
          provider          => 'github',
          redirect_url      => 'https://foo.example.org/oauth2/callback',
          email_domains     => [ '*' ],
        }
      }

      ::oauth2_proxy::instance { 'proxy2':
        config => {
          http_address      => '127.0.0.1:4182',
          client_id         => '1234',
          client_secret     => 'abcd',
          github_org        => 'foo',
          upstreams         => [ 'http://127.0.0.1:3000' ],
          cookie_secret     => '1234',
          pass_access_token => false,
          pass_host_header  => true,
          provider          => 'github',
          redirect_url      => 'https://foo.example.org/oauth2/callback',
          email_domains     => [ '*' ],
        }
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe user('oauth2') do
    it { should exist }
    it { should have_home_directory '/' }
    it { should have_login_shell '/sbin/nologin' }
    it { should belong_to_group 'oauth2' }
  end

  describe group('oauth2') do
    it { should exist }
  end

  describe file('/opt/oauth2_proxy/bin/oauth2_proxy') do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by 'oauth2' }
    it { should be_grouped_into 'oauth2' }
  end

  describe file('/etc/oauth2_proxy/proxy1.conf') do
    it { should be_file }
    it { should be_mode 440 }
    it { should be_owned_by 'oauth2' }
    it { should be_grouped_into 'oauth2' }
    its(:content) do
      should match <<-EOS
client_id = "1234"
client_secret = "abcd"
cookie_secret = "1234"
email_domains = [
  "*"
]
github_org = "foo"
http_address = "127.0.0.1:4180"
pass_access_token = false
pass_host_header = true
provider = "github"
redirect_url = "https://foo.example.org/oauth2/callback"
upstreams = [
  "http://127.0.0.1:3000"
]
      EOS
    end
  end

  describe file('/etc/oauth2_proxy/proxy2.conf') do
    it { should be_file }
    it { should be_mode 440 }
    it { should be_owned_by 'oauth2' }
    it { should be_grouped_into 'oauth2' }
    its(:content) do
      should match <<-EOS
http_address = "127.0.0.1:4182"
      EOS
    end
  end


  %w[ proxy1 proxy2 ].each do | name |
    describe service("oauth2_proxy-#{name}") do
      it { should be_enabled }
      it { should be_running }
    end
  end

  [4180, 4182].each do | port |
    describe port(port) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end
end
