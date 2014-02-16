#
# Cookbook Name:: linux
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## package install

%w{ vim telnet }.each do |pack|
  package pack do
    action :install
  end
end
