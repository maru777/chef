#
# Cookbook Name:: linux
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## package install

%w{ vim telnet man }.each do |pack|
  package pack do
    action :install
  end
end

execute "nettools" do
  command 'yum -y groupinstall "Networking Tools"'
  action :run
end

file "/etc/profile" do
  rc = Chef::Util::FileEdit.new(path)
  my_profile = '[ -e /etc/my_profile ] && . /etc/my_profile'
  rc.insert_line_if_no_match( my_profile, "#{my_profile}\n")
  content rc.send(:contents).join
  action :create
end

template "/etc/my_profile" do
  source "env/my_profile.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/usr/share/vim/vimrc" do
  source "env/vimrc.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end


