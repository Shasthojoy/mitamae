execute 'apt-get update'
package 'ruby'

gem_package 'tzinfo' do
  version '1.1.0'
end

gem_package 'tzinfo' do
  version '1.2.2'
end

gem_package 'bundler' do
  options ['--no-ri', '--no-rdoc']
end

gem_package 'unindent' do
  version '0.9'
end

gem_package 'unindent' do
  version '1.0'
end

gem_package 'unindent' do
  action :uninstall
  version '1.0'
end

gem_package 'test-unit' do
  version '3.2.0'
end

gem_package 'test-unit' do
  version '3.1.9'
end

gem_package 'test-unit' do
  action :uninstall
end
