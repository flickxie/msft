#!/bin/bash
# k8s镜像，需在科学环境下载
# 脚本执行后将生成 k8s-v1.21.5.tgz的压缩包，其中包含k8s组件的各个镜像

# VERSION=v1.21.5
VERSION=$1
DIR=k8s-${VERSION}
# conformance
# kube-apiserver
# kube-proxy
# kube-controller-manager
# kube-scheduler

if [[ $# == 0 ]] || [[ "$1" == "-h" ]]; then
    echo "sh k8s-download.sh v1.21.5"
    exit 1
fi

mkdir -p ${DIR}/bin ${DIR}/dockerimage
for i in conformance kube-apiserver kube-proxy kube-controller-manager kube-scheduler
    do
        docker pull registry.k8s.io/${i}:${VERSION}
        docker save registry.k8s.io/${i}:${VERSION} > ${DIR}/dockerimage/$i-${VERSION}.tar
done

for i in apiextensions-apiserver kube-aggregator kube-apiserver kube-controller-manager kube-log-runner kube-proxy kube-scheduler kubeadm kubectl kubectl-convert kubelet mounter
    do
        wget -P ${DIR}/bin/ https://dl.k8s.io/${VERSION}/bin/linux/amd64/${i}
done

tar -czf ${DIR}.tgz ${DIR}
for i in conformance kube-apiserver kube-proxy kube-controller-manager kube-scheduler
    do
        docker rmi registry.k8s.io/${i}:${VERSION}
done
rm -rf ./${DIR}/
