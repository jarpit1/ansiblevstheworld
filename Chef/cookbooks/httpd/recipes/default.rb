#
# Cookbook:: httpd
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
package 'httpd' do #package defines package resource, httpd defines the specific package
  action :install #specifies action for package resource, install httpd
end

service 'httpd' do #service resource, httpd service
  action [ :enable, :start ] #enable and start the httpd service
end

cookbook_file "/var/www/html/index.html" do #cookbook_file: resource to transfer files from httpd/files cookbook to the specified path
  source "index.html" #file to transfer from httpd/files
  mode "0644" #sets permissions for the file
end
