#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "=============================Install kvm qemu libvirt============================================================="
apt-get -qq update
apt-get install -y cpu-checker bridge-utils dnsmasq-base ebtables libvirt-bin libvirt-dev qemu-kvm qemu-utils ruby-dev
systemctl status libvirtd
libvirtd --version
egrep -c '(vmx|svm)' /proc/cpuinfo #If 0 it means that your CPU doesn't support hardware virtualization.If 1 or more it does - but you still need to make sure that virtualization is enabled in the BIOS.
addgroup libvirtd
adduser  $(id -un) libvirtd #ensure that your username is added to the group libvirtd
kvm-ok
echo "=============================Install Vagrant============================================================="
export VAGRANT_CURRENT_VERSION="$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r -M '.current_version')"
# export VAGRANT_CURRENT_VERSION="2.2.9"
apt-get install -qqy unzip jq

# https://www.vagrantup.com/downloads.html
# https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_SHA256SUMS
VAGRANT_URL="https://releases.hashicorp.com/vagrant/${VAGRANT_CURRENT_VERSION}/vagrant_${VAGRANT_CURRENT_VERSION}_x86_64.deb"
export VAGRANT_SHA256_URL="https://releases.hashicorp.com/vagrant/$VAGRANT_CURRENT_VERSION/vagrant_${VAGRANT_CURRENT_VERSION}_SHA256SUMS"
export  VAGRANT_SHA256_SIG_URL="https://releases.hashicorp.com/vagrant/$VAGRANT_CURRENT_VERSION/vagrant_${VAGRANT_CURRENT_VERSION}_SHA256SUMS.sig"

# wget -nv https://releases.hashicorp.com/vagrant/${VAGRANT_CURRENT_VERSION}/vagrant_${VAGRANT_CURRENT_VERSION}_x86_64.deb
curl -LO "${VAGRANT_URL}"
curl -LO "${VAGRANT_SHA256_URL}"
curl -LO "${VAGRANT_SHA256_SIG_URL}"
export HASHICORP_PUBLIC_KEY_URL="https://keybase.io/hashicorp/pgp_keys.asc" #https://www.hashicorp.com/security
export 'curl -sSL "${HASHICORP_PUBLIC_KEY_URL}" | gpg --import -' # import the public key (PGP key)
gpg --verify "vagrant_${VAGRANT_CURRENT_VERSION}_SHA256SUMS.sig" "vagrant_${VAGRANT_CURRENT_VERSION}_SHA256SUMS" 2>/dev/null #Verify the signature file is untampered
shasum -a 256 -c "vagrant_${VAGRANT_CURRENT_VERSION}_SHA256SUMS" | sudo tee output.txt  # Verify the SHASUM matches the archive.
cat output.txt  | grep OK # print OK

dpkg -i vagrant_${VAGRANT_CURRENT_VERSION}_x86_64.deb
vagrant version
echo "========================================================================================="
vagrant plugin install vagrant-libvirt #The vagrant-libvirt plugin is required when using KVM on Linux
vagrant plugin install vagrant-mutate #Convert vagrant boxes to work with different providers

vagrant box add "ubuntu/groovy64" --provider=virtualbox
vagrant mutate "ubuntu/groovy64"  libvirt

vagrant box add "ubuntu/focal64" --provider=virtualbox
vagrant mutate "ubuntu/focal64" libvirt

 vagrant up --provider=libvirt
#travis_wait 15 sudo vagrant up --provider=libvirt

vagrant box list #veridy installed boxes
vagrant status #Check the status of the VMs to see that none of them have been created yet
vagrant status
virsh list --all #show all running KVM/libvirt VMs
