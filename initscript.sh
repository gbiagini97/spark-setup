#!/bin/sh

apt update
apt install wget 
cd /home

mkdir sibylla
export SIBYLLA_HOME="/home/sibylla"

mkdir java
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar -xzvf openjdk-11+28_linux-x64_bin.tar.gz -C java/
export JAVA_HOME="/home/java/jdk-11"
