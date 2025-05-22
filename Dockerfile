FROM ubuntu:22.04

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y openjdk-11-jdk
RUN apt install -y openssh-server ssh wget vim sudo net-tools
RUN apt clean

# ENVIRONMENT VARIABLE = bashrc
ENV HADOOP_HOME=/usr/local/hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin  
ENV HADOOP_INSTALL=$HADOOP_HOME  
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME  
ENV HADOOP_COMMON_HOME=$HADOOP_HOME  
ENV HADOOP_HDFS_HOME=$HADOOP_HOME  
ENV HADOOP_YARN_HOME=$HADOOP_HOME  
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native  
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
ENV ZOOKEEPER_HOME=/usr/local/zookeeper/bin/zkServer.sh
ENV HBASE_HOME=/usr/local/hbase
ENV PATH=$PATH:$HBASE_HOME/bin

RUN addgroup hadoop-group
RUN adduser --disabled-password --gecos "" --ingroup hadoop-group hadoop
RUN echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install ZooKeeper
RUN wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz 
RUN tar -xvzf apache-zookeeper-3.8.4-bin.tar.gz -C /usr/local
RUN mv /usr/local/apache-zookeeper-3.8.4-bin /usr/local/zookeeper
RUN mkdir -p /usr/local/zookeeper/data
RUN chown -R hadoop:hadoop-group /usr/local/zookeeper
RUN chmod -R 777 /usr/local/zookeeper

# Install Hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
RUN tar -xvzf hadoop-3.3.6.tar.gz -C /usr/local
RUN sudo mv /usr/local/hadoop-3.3.6 /usr/local/hadoop
RUN sudo chown -R hadoop:hadoop-group /usr/local/hadoop
RUN sudo chmod -R 777 /usr/local/hadoop

# Install HBase
RUN wget https://archive.apache.org/dist/hbase/2.5.7/hbase-2.5.7-bin.tar.gz
RUN tar -xvzf hbase-2.5.7-bin.tar.gz -C /usr/local
RUN mv /usr/local/hbase-2.5.7 /usr/local/hbase
RUN chown -R hadoop:hadoop-group /usr/local/hbase
RUN chmod -R 777 /usr/local/hbase

# switch user to hadoop
USER hadoop 
WORKDIR /home/hadoop

RUN ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

# Copy configuration files
COPY hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY workers $HADOOP_HOME/etc/hadoop/workers
COPY zoo.cfg /usr/local/zookeeper/conf/zoo.cfg

# Copy HBase configuration files
COPY hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
COPY hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
COPY regionservers $HBASE_HOME/conf/regionservers

# Create necessary directories
RUN sudo mkdir -p /hadoop/dfs/name
RUN sudo chmod -R 777 /hadoop/dfs/name
RUN sudo chown -R hadoop:hadoop-group /hadoop/dfs/name
RUN sudo mkdir -p /hadoop/dfs/data
RUN sudo chmod -R 777 /hadoop/dfs/data
RUN sudo chown -R hadoop:hadoop-group /hadoop/dfs/data
RUN sudo mkdir -p /hadoop/hbase/logs
RUN sudo mkdir -p /hadoop/hbase/tmp && sudo chmod -R 777 /hadoop

ENV HBASE_ROLE=all
ENV HBASE_MASTER_NUM=1

COPY entrypoint.sh /home/hadoop/entrypoint.sh
RUN sudo chmod +x ~/entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
