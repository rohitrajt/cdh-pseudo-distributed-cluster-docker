#!/bin/bash

service hadoop-hdfs-namenode start
service hadoop-hdfs-datanode start

sudo service hadoop-yarn-resourcemanager start 
sudo service hadoop-yarn-nodemanager start 
sudo service hadoop-mapreduce-historyserver start

sudo -u hdfs hadoop fs -mkdir /user/hdfs
sudo -u hdfs hadoop fs -chown hdfs /user/hdfs

#init oozie
sudo -u hdfs hadoop fs -mkdir /user/oozie
sudo -u hdfs hadoop fs -chown oozie:oozie /user/oozie
sudo oozie-setup sharelib create -fs hdfs://localhost:8020 -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz

service oozie start

sleep 1

# tail log directory
tail -n 1000 -f /var/log/hadoop-*/*.out