#!/usr/bin/env bash
export PS1='[\W:\u]\$ '
cd /vagrant/
echo "Your are here: $(pwd)"
cat '/vagrant/files/util/vagrant/welcome.txt'

~/vault_setup.sh

. ~/.bashrc
