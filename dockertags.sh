#!/bin/bash
#获取公用仓库里镜像的tag列表
#只能获取到第一页的，官方的镜像
if [ $# -lt 1 ]
then
cat << HELP

dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE: 
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache

HELP
fi

image="$1"
tags=`wget -q https://registry.hub.docker.com/v2/repositories/library/${image}/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'|grep name|awk -F',' '{print $5}'|awk -F'name:' '{print $NF}'`

if [ -n "$2" ]
then
    tags=` echo "${tags}" | grep "$2" `
fi

echo "${tags}"
