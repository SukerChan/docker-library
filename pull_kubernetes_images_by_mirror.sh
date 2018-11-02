#!/bin/bash

set -e

# Check version in https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
# Search "Running kubeadm without an internet connection"
# For running kubeadm without an internet connection you have to pre-pull the required master images for the version of choice:
KUBE_VERSION=v1.12.2
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.2.24
DNS_VERSION=1.14.13

GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-shenzhen.aliyuncs.com/0916chen
MIRROR_URL=mirrorgooglecontainers
DOCKER_URL=docker.io

images=(kube-proxy:${KUBE_VERSION}
kube-scheduler:${KUBE_VERSION}
kube-controller-manager:${KUBE_VERSION}
kube-apiserver:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
etcd:${ETCD_VERSION}
k8s-dns-sidecar:${DNS_VERSION}
k8s-dns-kube-dns:${DNS_VERSION}
k8s-dns-dnsmasq-nanny:${DNS_VERSION})


for imageName in ${images[@]} ; do
  docker pull $MIRROR_URL/$imageName
  docker tag  $DOCKER_URL/$MIRROR_URL/$imageName $GCR_URL/$imageName
  docker rmi $DOCKER_URL/$MIRROR_URL/$imageName
done

docker images

