require 'spec_helper'

describe 'oauth2_proxy', :type => :class do
  describe 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat', :architecture => 'x86_64' }}

    context 'parameters' do
      context 'user =>' do
        context '(unset)' do
          it do
            should contain_user('oauth2').with(
              :gid    => 'oauth2',
              :system => true,
              :home   => '/',
              :shell  => '/sbin/nologin'
            )
          end
        end

        context 'foo' do
          let(:params) {{ :user => 'foo' }}
          it { should contain_user('foo') }
        end

        context 'true' do
          let(:params) {{ :user => true }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a string/)
          end
        end
      end # user =>

      context 'manage_user =>' do
        context '(unset)' do
          it { should contain_user('oauth2') }
        end

        context 'true' do
          let(:params) {{ :manage_user => true }}
          it { should contain_user('oauth2') }
        end

        context 'false' do
          let(:params) {{ :manage_user => false }}
          it { should_not contain_user('oauth2') }
        end

        context 'foo' do
          let(:params) {{ :manage_user => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a bool/)
          end
        end
      end # manage_user =>

      context 'group =>' do
        context '(unset)' do
          it do
            should contain_group('oauth2').with(
              :system => true
            )
          end
        end

        context 'foo' do
          let(:params) {{ :group => 'foo' }}
          it { should contain_group('foo') }
        end

        context 'true' do
          let(:params) {{ :group => true }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a string/)
          end
        end
      end # group =>

      context 'manage_group =>' do
        context '(unset)' do
          it { should contain_group('oauth2') }
        end

        context 'true' do
          let(:params) {{ :manage_group => true }}
          it { should contain_group('oauth2') }
        end

        context 'false' do
          let(:params) {{ :manage_group => false }}
          it { should_not contain_group('oauth2') }
        end

        context 'foo' do
          let(:params) {{ :manage_group => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a bool/)
          end
        end
      end # manage_group =>

      context 'install_root =>' do
        context '(unset)' do
          it do
            should contain_file('/opt/oauth2_proxy').with(
              :owner => 'oauth2',
              :group => 'oauth2',
              :mode  => '0755'
            )
          end
        end

        context '/dne' do
          let(:params) {{ :install_root => '/dne' }}
          it { should contain_file('/dne') }
        end

        context 'foo' do
          let(:params) {{ :install_root => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not an absolute path/)
          end
        end
      end # install_root =>

      context 'source =>' do
        context '(unset)' do
          it do
            should contain_archive('oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz').with(
              :ensure        => :present,
              :source        => 'https://github.com/bitly/oauth2_proxy/releases/download/v2.0.1/oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz',
              :path          => '/opt/oauth2_proxy/oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz',
              :extract       => true,
              :extract_path  => '/opt/oauth2_proxy',
              :checksum_type => 'sha1',
              :user          => 'oauth2'
            )
          end
        end

        context 'https://example.org/foo.tar.gz' do
          let(:params) {{ :source => 'https://example.org/foo.tar.gz' }}

          it do
            should contain_archive('foo.tar.gz').with(
              :ensure        => :present,
              :source        => 'https://example.org/foo.tar.gz',
              :path          => '/opt/oauth2_proxy/foo.tar.gz',
              :extract       => true,
              :extract_path  => '/opt/oauth2_proxy',
              :checksum_type => 'sha1',
              :user          => 'oauth2'
            )
          end
        end

        context 'foo' do
          let(:params) {{ :source => [] }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a string/)
          end
        end
      end # source =>

      context 'checksum =>' do
        context '(unset)' do
          it do
            should contain_archive('oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz').with(
              :checksum => '950e08d52c04104f0539e6945fc42052b30c8d1b',
            )
          end
        end

        context 'asdf' do
          let(:params) {{ :checksum => 'asdf' }}

          it do
            should contain_archive('oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz').with(
              :checksum => 'asdf',
            )
          end
        end

        context 'foo' do
          let(:params) {{ :checksum => [] }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a string/)
          end
        end
      end # checksum =>
    end # parameters

    describe 'systemd service' do
      examples = {
        "User=foo\n"                      => { 'user'         => 'foo' },
        "Group=bar\n"                     => { 'group'        => 'bar' },
        "ExecStart=/dne/bin/oauth2_proxy" => { 'install_root' => '/dne' },
      }

      examples.each do |output, config|
        context config do
          let(:params) { config }

          it do
            should contain_file('/usr/lib/systemd/system/oauth2_proxy@.service').with(
              :ensure => 'file',
              :owner  => 'root',
              :group  => 'root',
              :mode   => '0644'
            ).with_content(/#{output}/)
          end
        end
      end
    end # systemd service

    describe 'on architecture x86' do
      let(:facts) {{ :osfamily => 'RedHat', :architecture => 'x86' }}
      it { should compile.and_raise_error(/is not supported on architecture/) }
    end
  end # for osfamily RedHat

  describe 'for osfamily Debian' do
    let(:facts) {{ :osfamily => 'foo', :operatingsystem => 'bar' }}
    it { should compile.and_raise_error(/is not supported on operatingsystem/) }
  end
end
