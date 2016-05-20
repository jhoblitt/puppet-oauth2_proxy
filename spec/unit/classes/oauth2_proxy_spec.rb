require 'spec_helper'

describe 'oauth2_proxy', :type => :class do
  describe 'for osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat', :architecture => 'x86_64' }}

    context 'parameters' do
      context 'user =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
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
          let(:params) {{ :config => {}, :user => 'foo' }}
          it { should contain_user('foo') }
        end

        context 'true' do
          let(:params) {{ :config => {}, :user => true }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a string/)
          end
        end
      end # user =>

      context 'manage_user =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it { should contain_user('oauth2') }
        end

        context 'true' do
          let(:params) {{ :config => {}, :manage_user => true }}
          it { should contain_user('oauth2') }
        end

        context 'false' do
          let(:params) {{ :config => {}, :manage_user => false }}
          it { should_not contain_user('oauth2') }
        end

        context 'foo' do
          let(:params) {{ :config => {}, :manage_user => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a bool/)
          end
        end
      end # manage_user =>

      context 'group =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it do
            should contain_group('oauth2').with(
              :system => true
            )
          end
        end

        context 'foo' do
          let(:params) {{ :config => {}, :group => 'foo' }}
          it { should contain_group('foo') }
        end

        context 'true' do
          let(:params) {{ :config => {}, :group => true }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a string/)
          end
        end
      end # group =>

      context 'manage_group =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it { should contain_group('oauth2') }
        end

        context 'true' do
          let(:params) {{ :config => {}, :manage_group => true }}
          it { should contain_group('oauth2') }
        end

        context 'false' do
          let(:params) {{ :config => {}, :manage_group => false }}
          it { should_not contain_group('oauth2') }
        end

        context 'foo' do
          let(:params) {{ :config => {}, :manage_group => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a bool/)
          end
        end
      end # manage_group =>

      context 'install_root =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it do
            should contain_file('/opt/oauth2_proxy').with(
              :owner => 'oauth2',
              :group => 'oauth2',
              :mode  => '0755'
            )
          end
        end

        context '/dne' do
          let(:params) {{ :config => {}, :install_root => '/dne' }}
          it { should contain_file('/dne') }
        end

        context 'foo' do
          let(:params) {{ :config => {}, :install_root => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not an absolute path/)
          end
        end
      end # install_root =>

      context 'manage_service =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it do
            should contain_service('oauth2_proxy').with(
              :ensure => 'running',
              :enable => true
            )
          end
        end

        context 'true' do
          let(:params) {{ :config => {}, :manage_service => true }}
          it { should contain_service('oauth2_proxy') }
        end

        context 'false' do
          let(:params) {{ :config => {}, :manage_service => false }}
          it { should_not contain_service('oauth2_proxy') }
        end

        context 'foo' do
          let(:params) {{ :config => {}, :manage_service => 'foo' }}
          it 'should fail' do
            should raise_error(Puppet::Error, /is not a bool/)
          end
        end
      end # manage_service =>

      context 'config =>' do
        context '(unset)' do
          it 'is mandatory' do
            should compile.and_raise_error(/config/)
          end
        end

        # the goal here is to test how the ERB template serializes the config
        #hash
        examples = {
          "bool1 = true\n"                          => { 'bool1'   => true },
          "bool2 = false\n"                         => { 'bool2'   => false },
          "string1 = \"foo\"\n"                     => { 'string1' => 'foo' },
          "string2 = \"bar\"\n"                     => { 'string2' => 'bar' },
          "array1 = [\n  \"baz\"\n]\n"              => { 'array1'  => [ 'baz' ] },
          "array2 = [\n  \"quix\"\n  \"fuzz\"\n]\n" => { 'array2'  => [ 'quix', 'fuzz'] },
        }

        examples.each do |output, config|
          context config  do
            let(:params) {{ :config => config }}

            it do
              should contain_file('/etc/oauth2_proxy/oauth2_proxy.conf').with(
                :ensure => 'file',
                :owner => 'oauth2',
                :group => 'oauth2',
                :mode => '0440'
              ).with_content(output)
            end
          end
        end

        context 'foo' do
          let(:params) {{ :config => 'foo' }}

          it 'should fail' do
            should raise_error(Puppet::Error, /is not a Hash/)
          end
        end
      end # config =>

    end # parameters

    describe 'on architecture x86' do
      let(:facts) {{ :osfamily => 'RedHat', :architecture => 'x86' }}
      let(:params) {{ :config => {} }}
      it { should compile.and_raise_error(/is not supported on architecture/) }
    end
  end # for osfamily RedHat

  describe 'for osfamily Debian' do
    let(:facts) {{ :osfamily => 'foo', :operatingsystem => 'bar' }}
    let(:params) {{ :config => {} }}
    it { should compile.and_raise_error(/is not supported on operatingsystem/) }
  end
end
