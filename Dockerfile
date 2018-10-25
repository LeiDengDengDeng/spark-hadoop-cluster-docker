FROM ubuntu:14.04

WORKDIR /root

# install openssh-server and wget
RUN apt-get update && apt-get install -y openssh-server wget

# install jdk8
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz && \
    mkdir /usr/lib/jvm && \
    tar -xzvf jdk-8u191-linux-x64.tar.gz -C /usr/lib/jvm && \
    rm jdk-8u191-linux-x64.tar.gz

# install hadoop 2.7.2
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# install scala 2.12.7
RUN wget "https://downloads.lightbend.com/scala/2.12.7/scala-2.12.7.tgz" && \
    tar -xzvf scala-2.12.7.tgz && \
    mv scala-2.12.7 /usr/local/scala && \
    rm scala-2.12.7.tgz

# install spark 2.3.2
RUN wget -O "spark-2.3.2-bin-hadoop2.7.tgz" "http://mirrors.hust.edu.cn/apache/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz" && \
    tar -xvf spark-2.3.2-bin-hadoop2.7.tgz  && \
    mv spark-2.3.2-bin-hadoop2.7 /usr/local/spark-2.3.2-bin-hadoop2.7 && \
    rm spark-2.3.2-bin-hadoop2.7.tgz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_191
ENV HADOOP_HOME=/usr/local/hadoop 
ENV SCALA_HOME=/usr/local/scala
ENV SPARK_HOME=/usr/local/spark-2.3.2-bin-hadoop2.7
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SCALA_HOME/bin:$SPARK_HOME/bin:${JAVA_HOME}/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/stop-hadoop.sh ~/stop-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
    mv /tmp/spark-slaves $SPARK_HOME/conf/slaves

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/stop-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

