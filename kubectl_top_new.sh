#!/bin/bash -e
FIO_RES_REPO=/home/sfdev/yd/fiotest/kubevirt_spdk_res
set -x
sleep 30

while [ -n "`ps -ef |grep ssh |grep seqwrite`" ];do
    echo "$1 time seqwrite..."
    kubectl top pod -n rook-ceph >> ${FIO_RES_REPO}/seqwrite/$1/kubectl_top_res
    sleep 5
done
sleep 30
while [ -n "`ps -ef |grep ssh |grep seqread`" ];do
    echo "$1 time seqread..."
    kubectl top pod -n rook-ceph >> ${FIO_RES_REPO}/seqread/$1/kubectl_top_res
    sleep 5
done
sleep 30
while [ -n "`ps -ef |grep ssh |grep randwrite`" ];do
    echo "$1 time randwrite..."
    kubectl top pod -n rook-ceph >> ${FIO_RES_REPO}/randwrite/$1/kubectl_top_res
    sleep 5
done
sleep 30
while [ -n "`ps -ef |grep ssh |grep randread`" ];do
    echo "$1 time randread..."
    kubectl top pod -n rook-ceph >> ${FIO_RES_REPO}/randread/$1/kubectl_top_res
    sleep 5
done

