## Run Spark&Hadoop Cluster within Docker Containers


### 3 Nodes Spark&Hadoop Cluster

##### 1. clone github repository

```
git clone https://github.com/LeiDengDengDeng/spark-hadoop-cluster-docker.git
```

##### 2. build docker image

```
cd spark-hadoop-cluster-docker
sudo ./build-img.sh
```

##### 3. create network

```
sudo docker network create --driver=bridge hadoop
```

##### 4. start container

```
sudo ./start-container.sh
```

**output:**

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container

##### 5. start hadoop&spark

```
./start-hadoop.sh
```

##### 6. run wordcount

```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

##### 7. run spark

```
spark-shell
> val file=sc.textFile("hdfs://hadoop:master:9000/input/file1.txt")
> val rdd = file.flatMap(line => line.split(" ")).map(word => (word,1)).reduceByKey(_+_)
> rdd.collect()
> rdd.foreach(println)
```



