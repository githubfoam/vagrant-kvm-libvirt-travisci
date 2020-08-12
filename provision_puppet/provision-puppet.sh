#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "=============================provision Vagrantfile with puppet============================================================="

cd provision_puppet && vagrant init --template Vagrantfile.template.erb 
vagrant up          

echo "=============================provision Vagrantfile with puppet============================================================="