source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

group :development, :test do
  gem 'rake',                     :require => false
  gem 'rspec', '~> 3.2',          :require => false
  gem 'puppetlabs_spec_helper',   :require => false
  gem 'puppet-lint', '>= 1.1.0',  :require => false
  gem 'puppet-syntax',            :require => false
  gem 'rspec-puppet', '~> 2.2',   :require => false
  gem 'metadata-json-lint',       :require => false
  gem 'travis', '~> 1.8',         :require => false
end

group :beaker do
  gem 'serverspec',               :require => false
  gem 'beaker',                   :require => false
  gem 'beaker-rspec',             :require => false
  gem 'pry',                      :require => false
  gem 'puppet-blacksmith',        :require => false
  gem 'vagrant-wrapper',          :require => false
end

# vim:ft=ruby
