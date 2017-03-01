require 'spec_helper'

describe 'oauth2_proxy::instance', :type => :define do
  describe 'for osfamily RedHat' do
    let :pre_condition do
      'include ::oauth2_proxy'
    end
    let(:facts) {{ :osfamily => 'RedHat', :architecture => 'x86_64', :os => { :family => 'RedHat' }, :operatingsystem => 'CentOS' }}
    let(:title) { 'proxy1' }

    context 'parameters' do
      context 'manage_service =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it do
            should contain_service("oauth2_proxy@#{title}").with(
              :ensure => 'running',
              :enable => true
            )
          end
        end

        context 'true' do
          let(:params) {{ :config => {}, :manage_service => true }}
          it { should contain_service("oauth2_proxy@#{title}") }
        end

        context 'false' do
          let(:params) {{ :config => {}, :manage_service => false }}
          it { should_not contain_service("oauth2_proxy@#{title}") }
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
          "bool1 = true\n"                            => { 'bool1'   => true },
          "bool2 = false\n"                           => { 'bool2'   => false },
          "string1 = \"foo\"\n"                       => { 'string1' => 'foo' },
          "string2 = \"bar\"\n"                       => { 'string2' => 'bar' },
          "array1 = [\n  \"baz\",\n]\n"               => { 'array1'  => [ 'baz' ] },
          "array2 = [\n  \"quix\",\n  \"fuzz\",\n]\n" => { 'array2'  => [ 'quix', 'fuzz'] },
        }

        examples.each do |output, config|
          context config  do
            let(:params) {{ :config => config }}

            it do
              should contain_file("/etc/oauth2_proxy/#{title}.conf").with(
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
  end # for osfamily RedHat

  describe 'for osfamily Debian' do
    let :pre_condition do
      'include ::oauth2_proxy'
    end
    let(:facts) {{ :osfamily => 'Debian', :architecture => 'amd64', :os => { :family => 'Debian' }, :operatingsystem => 'ubuntu' }}
    let(:title) { 'proxy1' }

    context 'parameters' do
      context 'manage_service =>' do
        context '(unset)' do
          let(:params) {{ :config => {} }}
          it do
            should contain_service("oauth2_proxy@#{title}").with(
              :ensure => 'running',
              :enable => true
            )
          end
        end

        context 'true' do
          let(:params) {{ :config => {}, :manage_service => true }}
          it { should contain_service("oauth2_proxy@#{title}") }
        end

        context 'false' do
          let(:params) {{ :config => {}, :manage_service => false }}
          it { should_not contain_service("oauth2_proxy@#{title}") }
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
          "bool1 = true\n"                            => { 'bool1'   => true },
          "bool2 = false\n"                           => { 'bool2'   => false },
          "string1 = \"foo\"\n"                       => { 'string1' => 'foo' },
          "string2 = \"bar\"\n"                       => { 'string2' => 'bar' },
          "array1 = [\n  \"baz\",\n]\n"               => { 'array1'  => [ 'baz' ] },
          "array2 = [\n  \"quix\",\n  \"fuzz\",\n]\n" => { 'array2'  => [ 'quix', 'fuzz'] },
        }

        examples.each do |output, config|
          context config  do
            let(:params) {{ :config => config }}

            it do
              should contain_file("/etc/oauth2_proxy/#{title}.conf").with(
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
  end # for osfamily Debian
end
