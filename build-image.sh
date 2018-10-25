#!/bin/bash

echo ""

echo -e "\nbuild docker spark&hadoop image\n"
sudo docker build -t deng/hadoop:1.0 .

echo ""