#!/bin/sh

mkdir -p $SIBYLLA_HOME/3rd-party/spark-domain/spark-jdk
mkdir -p $SIBYLLA_HOME/3rd-party/spark-domain/spark-home

#to be removed
mkdir $SIBYLLA_HOME/downloads

#download and uncompress jdk8
wget -P $SIBYLLA_HOME/downloads/ https://download.java.net/openjdk/jdk8u40/ri/openjdk_jre_ri-8u40-b25-linux-i586-10_feb_2015.tar.gz
tar -xzvf $SIBYLLA_HOME/downloads/openjdk_jre_ri-8u40-b25-linux-i586-10_feb_2015.tar.gz -C $SIBYLLA_HOME/3rd-party/spark-domain/spark-jdk
ln -s $SIBYLLA_HOME/3rd-party/spark-domain/spark-jdk/java-se-8u40-ri/ $SIBYLLA_HOME/3rd-party/spark-domain/jdk8

#download and uncompress spark
wget -P $SIBYLLA_HOME/downloads/ http://it.apache.contactlab.it/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
tar -xzvf $SIBYLLA_HOME/downloads/spark-2.4.4-bin-hadoop2.7.tgz -C $SIBYLLA_HOME/3rd-party/spark-domain/spark-home
ln -s $SIBYLLA_HOME/3rd-party/spark-domain/spark-home/spark-2.4.4-bin-hadoop2.7 $SIBYLLA_HOME/3rd-party/spark-domain/spark

# TO UPDATE WITH SPARK-CLASS FILE HOSTED BY GV REPO
# set spark to run with jdk8
rm -f $SIBYLLA_HOME/3rd-party/spark-domain/spark/bin/spark-class
wget -P $SIBYLLA_HOME/3rd-party/spark-domain/spark/bin/ https://github.com/gbiagini97/spark-setup/releases/download/spark-class-1.0/spark-class 
chmod a+x $SIBYLLA_HOME/3rd-party/spark-domain/spark/bin/spark-class

# configure spark-defaults with mongo-spark connector
cp $SIBYLLA_HOME/3rd-party/spark-domain/spark/conf/spark-defaults.conf.template $SIBYLLA_HOME/3rd-party/spark-domain/spark/conf/spark-defaults.conf
echo "spark.jars.packages             org.mongodb.spark:mongo-spark-connector_2.11:2.4.1\nspark.mongodb.input.partitioner MongoSamplePartitioner" >>  $SIBYLLA_HOME/3rd-party/spark-domain/spark/conf/spark-defaults.conf



