#!/bin/bash
# k8s镜像，需在科学环境下载
# 脚本执行后将生成 k8s-v1.21.5.tgz的压缩包，其中包含k8s组件的各个镜像

# VERSION=v1.21.5
VERSION=$1
# conformance
# kube-apiserver
# kube-proxy
# kube-controller-manager
# kube-scheduler

if [[ $# == 0 ]] || [[ "$1" == "-h" ]]; then
    echo "sh k8s-download.sh v1.21.5"
    exit 1
fi

mkdir k8s-${VERSION}
for i in conformance kube-apiserver kube-proxy kube-controller-manager kube-scheduler
    do
        docker pull registry.k8s.io/${i}:${VERSION}
        docker save registry.k8s.io/${i}:${VERSION} > k8s-${VERSION}/$i-${VERSION}.tar
done
tar -czf k8s-${VERSION}.tgz k8s-${VERSION}
for i in conformance kube-apiserver kube-proxy kube-controller-manager kube-scheduler
    do
        docker rmi registry.k8s.io/${i}:${VERSION}
done
rm -rf ./k8s-${VERSION}/
