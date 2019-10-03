#!/bin/sh

#to be removed
mkdir $SIBYLLA_HOME/downloads

mkdir -p $SIBYLLA_HOME/3rd-party/spark-domain/
cd $SIBYLLA_HOME/3rd-party/spark-domain


#download and uncompress jdk8
wget -P $SIBYLLA_HOME/downloads/ https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz
tar -xzvf $SIBYLLA_HOME/downloads/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz -C .
ln -s java-se-8u40-ri jdk8

echo "JDK PORTABLE DOWNLOADED"
sleep 2

#update cacerts
rm -f jdk8/jre/lib/security/cacerts
wget -P jdk8/jre/lib/security/ https://github.com/gbiagini97/spark-setup/releases/download/spark-class-1.0/cacerts

echo "JDK CACERTS UPDATED"
sleep 2

#download and uncompress spark
wget -P $SIBYLLA_HOME/downloads/ http://it.apache.contactlab.it/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
tar -xzvf $SIBYLLA_HOME/downloads/spark-2.4.4-bin-hadoop2.7.tgz -C .
ln -s spark-2.4.4-bin-hadoop2.7 spark

echo "SPARK DOWNLOADED"
sleep 2


# TO UPDATE WITH SPARK-CLASS FILE HOSTED BY GV REPO
# set spark to run with jdk8
rm -f spark/bin/spark-class
wget -P spark/bin/ https://github.com/gbiagini97/spark-setup/releases/download/spark-class-1.0/spark-class 
chmod a+x spark/bin/spark-class

echo "SPARK SET TO RUN WITH JDK8"
sleep 2


# configure spark-defaults with mongo-spark connector
cp spark/conf/spark-defaults.conf.template spark/conf/spark-defaults.conf
echo "spark.jars.packages  org.mongodb.spark:mongo-spark-connector_2.11:2.4.1\n" >> spark/conf/spark-defaults.conf
echo "spark.mongodb.input.partitioner MongoSinglePartitioner\n" >> spark/conf/spark-defaults.conf

echo "UPDATED SPARK-DEFAULTS"
sleep 2

# configure spark env
cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh
echo "SPARK_MASTER_HOST=`hostname -i`" >> spark/conf/spark-env.sh
echo "SPARK_MASTER_WEBUI_PORT=8181" >> spark/conf/spark-env.sh

echo "UPDATED SPARK ENV"
sleep 2

# download and uncompress zeppelin
#wget -P $SIBYLLA_HOME/downloads/ http://it.apache.contactlab.it/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-all.tgz
#tar -xzvf $SIBYLLA_HOME/downloads/zeppelin-0.8.2-bin-all.tgz -C .
#ln -s zeppelin-0.8.2-bin-all zeppelin

wget -P $SIBYLLA_HOME/downloads/ http://mirror.nohup.it/apache/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-netinst.tgz
tar -xzvf $SIBYLLA_HOME/downloads/zeppelin-0.8.2-bin-netinst.tgz -C .
ln -s zeppelin-0.8.2-bin-netinst zeppelin


echo "ZEPPELIN DOWNLOADED"
sleep 2

# configure zeppelin runtime
rm -f zeppelin/bin/common.sh
wget -P zeppelin/bin/ https://github.com/gbiagini97/spark-setup/releases/download/spark-class-1.0/common.sh

echo "ZEPPELIN RUNTIME CONFIGURERD"
sleep 2

# configure zeppelin env
cp zeppelin/conf/zeppelin-env.sh.template zeppelin/conf/zeppelin-env.sh
echo "export SPARK_HOME=\$SIBYLLA_HOME/3rd-party/spark-domain/spark" >> zeppelin/conf/zeppelin-env.sh
echo "export PYTHONPATH=\$SPARK_HOME/python:\$SPARK_HOME/python/lib/py4j-0.10.7-src.zip" >> zeppelin/conf/zeppelin-env.sh
echo "export PATH=\$SPARK_HOME/python:\$SPARK_HOME/bin:\$PATH" >> zeppelin/conf/zeppelin-env.sh
echo "export ZEPPELIN_ADDR=0.0.0.0" >> zeppelin/conf/zeppelin-env.sh
echo "export ZEPPELIN_PORT=8282" >> zeppelin/conf/zeppelin-env.sh
echo "export MASTER='spark://`hostname -i`:7077'" >> zeppelin/conf/zeppelin-env.sh
echo "export ZEPPELIN_SPARK_MAXRESULT=5000" >> zeppelin/conf/zeppelin-env.sh

echo "ZEPPELIN CONFIGURED"
sleep 2
