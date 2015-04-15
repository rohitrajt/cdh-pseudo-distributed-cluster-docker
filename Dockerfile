FROM dockerfile/java:oracle-java7
MAINTAINER Rohit Raj Thirumurthy <rohitrajt@gmail.com>

#Base image doesn't start in root
WORKDIR /

#Install CDH
RUN curl http://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb > cdh5-repository_1.0_all.deb
RUN dpkg -i cdh5-repository_1.0_all.deb
RUN curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
RUN apt-get update 
RUN apt-get install -y hadoop-conf-pseudo
RUN apt-get install -y oozie

#Copy Updated Config file
ADD conf/core-site.xml /etc/hadoop/conf/core-site.xml
ADD conf/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
ADD conf/mapred-site.xml /etc/hadoop/conf/mapred-site.xml
ADD conf/hadoop-env.sh /etc/hadoop/conf/hadoop-env.sh
ADD conf/yarn-site.xml /etc/hadoop/conf/yarn-site.xml

#Format Namenode
RUN sudo -u hdfs hdfs namenode -format

ADD conf/run-cdh.sh /usr/bin/run-cdh.sh
RUN chmod +x /usr/bin/run-cdh.sh

RUN sudo -u oozie /usr/lib/oozie/bin/ooziedb.sh create -run
RUN curl http://archive.cloudera.com/gplextras/misc/ext-2.2.zip > ext.zip
RUN unzip ext.zip -d /var/lib/oozie

# NameNode (HDFS)
EXPOSE 8020 50070

# DataNode (HDFS)
EXPOSE 50010 50020 50075

# ResourceManager (YARN)
EXPOSE 8030 8031 8032 8033 8088

# NodeManager (YARN)
EXPOSE 8040 8042

# JobHistoryServer
EXPOSE 10020 19888

# Oozie
EXPOSE 11000

CMD ["/usr/bin/run-cdh.sh"]
