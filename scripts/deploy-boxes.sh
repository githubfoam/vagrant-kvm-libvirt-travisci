#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "========================================================================================="
vagrant plugin install vagrant-libvirt #The vagrant-libvirt plugin is required when using KVM on Linux
vagrant plugin install vagrant-mutate #Convert vagrant boxes to work with different providers

vagrant box add "ubuntu/groovy64" --provider=virtualbox
vagrant mutate "ubuntu/groovy64"  libvirt

vagrant box add "ubuntu/focal64" --provider=virtualbox
vagrant mutate "ubuntu/focal64" libvirt

vagrant up --provider=libvirt
# #travis_wait 15 sudo vagrant up --provider=libvirt

vagrant box list #veridy installed boxes
vagrant status #Check the status of the VMs to see that none of them have been created yet
vagrant status
virsh list --all #show all running KVM/libvirt VMs
