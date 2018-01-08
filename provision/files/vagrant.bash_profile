#!/usr/bin/env bash

cd /vagrant/
echo "Your are here: $(pwd)"
. ~/.bashrc
export PS1='[\W:\u]\$ '
