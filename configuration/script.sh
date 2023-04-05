#!/bin/bash
sudo apt update -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo npm -g install create-react-app
create-react-app simple-app
cd simple-app
npm start