#!/bin/sh

apt update
apt install wget 
mkdir /home/sibylla
export SIBYLLA_HOME=/home/sibylla
cd /home/sibylla
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar -xzvf openjdk-11+28_linux-x64_bin.tar.gz
export JAVA_HOME=jdk-11/
