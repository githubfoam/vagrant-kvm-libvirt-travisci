# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'

Vagrant.configure("2") do |config|

    template = ERB.new File.read("templates/Vagrantfile.template.erb")
    p template.result(binding)
end