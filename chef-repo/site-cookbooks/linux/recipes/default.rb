#
# Cookbook Name:: linux
# Recipe:: default
#
# Copyright 
#
# All rights reserved - Do Not Redistribute
#

u = data_bag_item("os_user", "root")
user "root" do
  password u["password"]
  action :modify
end


group "www-data" do
  action :modify
  members "maintenance"
  append true
end


u = data_bag_item("os_user", "vagrant")
user "bo-chef" do
  password u["password"]
  action :modify
end


# setenforce 0で一時的にSELinuxを無効化し、
# /etc/selinux/configの作成を通知する
# selinuxenabledコマンドの終了ステータスが0(selinuxが有効)の場合だけ実行される
execute "disable selinux enforcement" do
  only_if "which selinuxenabled && selinuxenabled"
  command "setenforce 0"
  action :run
  notifies :create, "template[/etc/selinux/config]"
end


# 再起動の際もSELinuxの無効状態を維持するために、
# /etc/selinux/configに、設定を記述する
template "/etc/selinux/config" do
  source "sysconfig/selinux.erb"
  variables(
    :selinux => "disabled",
    :selinuxtype => "targeted"
  )
  action :nothing
end



%w{ iptables ip6tables }.each do |srv|
  service srv do
    supports :restart => true
    action :nothing
  end
end

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/etc/sysconfig/iptables" do
  source "sysconfig/iptables.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[iptables]"
  notifies :restart, "service[ip6tables]"
  action :create
end

file "/etc/sudoers" do
  rc = Chef::Util::FileEdit.new(path)
  rc.search_file_replace(/(^Defaults\s+requiretty$)/, "#\\1")
  content rc.send(:contents).join
  action :create
end

file "/etc/sudoers" do
  rc = Chef::Util::FileEdit.new(path)
  rc.insert_line_if_no_match(/^%wheel\s*ALL=\(ALL\)\s*NOPASSWD:\s*ALL$/, "\n%wheel        ALL=(ALL)       NOPASSWD:ALL\n")
  content rc.send(:contents).join
  action :create
end



directory "/home/vagrant/.ssh" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end
