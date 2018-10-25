#!/bin/bash

echo ""

echo -e "\nbuild docker spark&hadoop image\n"
sudo docker build -t dengdenglei/spark-hadoop:1.0 .

echo ""