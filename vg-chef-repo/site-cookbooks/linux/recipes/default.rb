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

%w{ python-pygments }.each do |pack|
  package pack do
    action :install
  end
end

execute "nettools" do
  command 'yum -y groupinstall "Networking Tools"'
  action :run
end

directory "/etc/my_env" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

file "/etc/profile" do
  rc = Chef::Util::FileEdit.new(path)
  my_profile = '[ -f /etc/my_env/profile ] && . /etc/my_env/profile'
  rc.insert_line_if_no_match( my_profile, "#{my_profile}\n")
  content rc.send(:contents).join
  action :create
end

template "/etc/my_env/profile" do
  source "env/my_profile.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/etc/my_env/vimrc" do
  source "env/my_vimrc.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/etc/my_env/lessfilter" do
  source "env/lessfilter.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/usr/lib/python2.6/site-packages/pygments/styles/monokai.py" do
  source "env/monokai.py.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

