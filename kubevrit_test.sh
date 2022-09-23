#!/bin/bash -e
HOST=`hostname |awk -F "-" '{print$NF}'`
VM_56_IP=`kubectl get po -o wide |grep ceph56 |awk -F " " '{print $6}'`
VM_157_IP=`kubectl get po -o wide |grep ceph157 |awk -F " " '{print $6}'`
start_collect() {
        sleep 30
        seconds_per_monitor=10
        count=18
        (sar -P ALL $seconds_per_monitor $count >${RES_REPO}/$1/$2/${prefix}_sar-cpu-all.log) &
        (sar -u $seconds_per_monitor $count >${RES_REPO}/$1/$2/${prefix}_sar-cpu-uniq.log) &
        (sar -n DEV $seconds_per_monitor $count >${RES_REPO}/$1/$2/${prefix}_sar-net.log) &
        (sar -r $seconds_per_monitor $count >${RES_REPO}/$1/$2/${prefix}_sar-mem.log) &
        (sar -m CPU -P ALL $seconds_per_monitor $count >${RES_REPO}/$1/$2/${prefix}_sar-cpu-frequency.log) &
        (sar -d -p $seconds_per_monitor $count >${RES_REPO}/$1/$2/${prefix}_sar-io.log) &
}


if [ "$HOST" == "ceph56" ];then
        echo "ceph56"
        VM_IP=$VM_56_IP
        TEST_REPO=/home/sfdev/yd/fiotest
        RES_REPO=/home/sfdev/yd/fiotest/kubevirt_spdk_res
        prefix="KUBEVIRT_SPDK_IO_LOG"
        for i in {1..5..1};do
                mkdir -p $RES_REPO/seqwrite/$i
                mkdir -p $RES_REPO/seqread/$i
                mkdir -p $RES_REPO/randwrite/$i
                mkdir -p $RES_REPO/randread/$i

                (${TEST_REPO}/kubectl_top_new.sh $i) &
                (start_collect seqwrite $i) &
                echo "seqwrite $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/seqwrite.fio" > ${RES_REPO}/seqwrite/$i/seqwrite.fio.out 2>&1
                echo "seqwrite $i time completed!"

                (start_collect seqread $i) &
                echo "seqread $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/seqread.fio" > ${RES_REPO}/seqread/$i/seqread.fio.out 2>&1
                echo "seqread $i time completed!"

                (start_collect randwrite $i) &
                echo "randwrite $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/randwrite.fio" > ${RES_REPO}/randwrite/$i/randwrite.fio.out 2>&1
                echo "randwrite $i time completed!"

                (start_collect randread $i) &
                echo "randread $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/randread.fio" > ${RES_REPO}/randread/$i/randread.fio.out 2>&1
                echo "randread $i time completed!"
        done
        echo "++++++++++++++++++All Complete!+++++++++++++++++++"


elif [ "$HOST" == "ceph157" ];then
        echo "ceph 157"
        VM_IP=$VM_157_IP
        TEST_REPO=/home/smartedge-open/yd/fiotest
        RES_REPO=/home/smartedge-open/yd/fiotest/kubevirt_spdk_res
        prefix="KUBEVIRT_SPDK_IO_LOG"
        for i in {1..5..1};do
                mkdir -p $RES_REPO/seqwrite/$i
                mkdir -p $RES_REPO/seqread/$i
                mkdir -p $RES_REPO/randwrite/$i
                mkdir -p $RES_REPO/randread/$i

                #(${TEST_REPO}/kubectl_top_new.sh $i) &
                (start_collect seqwrite $i) &
                echo "seqwrite $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/seqwrite.fio" > ${RES_REPO}/seqwrite/$i/seqwrite.fio.out 2>&1
                echo "seqwrite $i time completed!"

                (start_collect seqread $i) &
                echo "seqread $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/seqread.fio" > ${RES_REPO}/seqread/$i/seqread.fio.out 2>&1
                echo "seqread $i time completed!"
		
		(start_collect randwrite $i) &
                echo "randwrite $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/randwrite.fio" > ${RES_REPO}/randwrite/$i/randwrite.fio.out 2>&1
                echo "randwrite $i time completed!"

                (start_collect randread $i) &
                echo "randread $i time monitoring..."
                ssh root@${VM_IP} "fio /home/fiotest/randread.fio" > ${RES_REPO}/randread/$i/randread.fio.out 2>&1
                echo "randread $i time completed!"
        done
        echo "++++++++++++++++++All Complete!+++++++++++++++++++"

else
        echo "Please check hostname"
fi

