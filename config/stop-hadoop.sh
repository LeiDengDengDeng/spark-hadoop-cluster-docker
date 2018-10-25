#!/bin/bash

echo -e "\n"

$HADOOP_HOME/sbin/stop-dfs.sh

echo -e "\n"

$HADOOP_HOME/sbin/stop-yarn.sh

echo -e "\n"

$SPARK_HOME/sbin/stop-all.sh

echo -e "\n"