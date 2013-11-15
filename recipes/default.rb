#
# Cookbook Name:: request-test
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

download_dir = '/usr/src'
package_url = 'http://download.splunk.com/releases/5.0.5/universalforwarder/linux/splunkforwarder-5.0.5-179365-linux-2.6-x86_64.rpm'
package_download_path = '/usr/src/splunkforwarder-5.0.5-179365-linux-2.6-x86_64.rpm'

directory download_dir

remote_file 'download-package' do
  action :nothing
  backup false
  path package_download_path
  source package_url
end

http_request 'splunkforwarder: Check Package URL' do
  action :head
  if ::File.exists?(package_download_path)
    headers 'If-Modified-Since' => ::File.mtime(package_download_path).httpdate
  end
  message ''
  notifies(:create,
           "remote_file[download-package]",
           :immediately)
  url package_url
end

package 'splunkforwarder' do
  source package_download_path
  provider Chef::Provider::Package::Rpm
end

