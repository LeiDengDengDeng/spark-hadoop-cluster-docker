## Run Spark&Hadoop Cluster within Docker Containers

### 3 Nodes Spark&Hadoop Cluster

##### 1. clone github repository

```
git clone https://github.com/LeiDengDengDeng/spark-hadoop-cluster-docker.git
cd spark-hadoop-cluster-docker
```

##### 2.get docker image(u can choose any one)

###### way 1: build it by yourself (it's (emmm very) slow but u can know the process of building image if u are interested in it)

```
sudo ./build-image.sh
```

###### way 2: pull image(fast and stable)

```
sudo docker pull dengdenglei/spark-hadoop:1.0
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
```

Now u have launched spark shell, then input following code(in scala) in spark shell:

```scala
val file=sc.textFile("hdfs://hadoop-master:9000/input/file1.txt")
val rdd = file.flatMap(line => line.split(" ")).map(word => (word,1)).reduceByKey(_+_)
rdd.collect()
rdd.foreach(println)
```

**output**

```
(Hello,1)
(Hadoop,1)
```

##### 8. website
```
localhost:8080
localhost:8088
localhost:50070
```

