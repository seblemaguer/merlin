#!/bin/bash

#########################################
######### Install Dependencies ##########
#########################################
#sudo apt-get -y install libncurses5 libncurses5-dev libcurses-ocaml # for sudo users only

current_working_dir=$(pwd)
tools_dir=${current_working_dir}/$(dirname $0)
cd $tools_dir
git clone git@github.com:seblemaguer/marytts-merlin-frontend.git
