#!/bin/bash
sudo apt update -y
sudo apt install nodejs -y
sudo apt install npm -y
git clone https://github.com/aditya-sridhar/simple-reactjs-app.git
cd simple-reactjs-app
npm install
npm start