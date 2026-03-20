#!/bin/sh

port=$2
nofast_port=`nv get nofast_port`

echo "\$1="$1", port="$port

if [ $1 == "add" ]
then
var="${nofast_port/"+"$port/}"
var="${var/$port/}"
var=$var"+"$port
elif [ $1 == "del" ]
then
var="${nofast_port/"+"$port/}"
var="${var/$port/}"
fi

nv set nofast_port=$var
echo $var > /proc/net/nofast_port

nv save

echo "var="+$var

