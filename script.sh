#!/bin/sh

#to be removed
mkdir $SIBYLLA_HOME/downloads

mkdir -p $SIBYLLA_HOME/3rd-party/spark-domain/
cd $SIBYLLA_HOME/3rd-party/spark-domain


#download and uncompress jdk8
wget -P $SIBYLLA_HOME/downloads/ https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz
tar -xzvf $SIBYLLA_HOME/downloads/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz -C .
ln -s java-se-8u40-ri jdk8

#update cacerts
rm -f jdk8/jre/lib/security/cacerts
wget -P jdk8/jre/lib/security/ https://github.com/gbiagini97/spark-setup/releases/download/spark-class-1.0/cacerts


#download and uncompress spark
wget -P $SIBYLLA_HOME/downloads/ http://it.apache.contactlab.it/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
tar -xzvf $SIBYLLA_HOME/downloads/spark-2.4.4-bin-hadoop2.7.tgz -C .
ln -s spark-2.4.4-bin-hadoop2.7 spark

# TO UPDATE WITH SPARK-CLASS FILE HOSTED BY GV REPO
# set spark to run with jdk8
rm -f spark/bin/spark-class
wget -P spark/bin/ https://github.com/gbiagini97/spark-setup/releases/download/spark-class-1.0/spark-class 
chmod a+x spark/bin/spark-class

# configure spark-defaults with mongo-spark connector
wget -P spark/jars https://repo1.maven.org/maven2/org/mongodb/mongodb-driver/3.10.2/mongodb-driver-3.10.2.jar
wget -P spark/jars https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/2.4.1/mongo-spark-connector_2.12-2.4.1.jar

cp spark/conf/spark-defaults.conf.template spark/conf/spark-defaults.conf
echo "spark.mongodb.input.partitioner MongoSamplePartitioner" >>  spark/conf/spark-defaults.conf

