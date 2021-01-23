#!/bin/bash

sudo apt -y update
sudo apt -y upgrade
sudo apt -y install emacs
sudo apt -y install trash-cli
./deploy.sh
