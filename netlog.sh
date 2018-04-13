#!/bin/bash
currentpath=`pwd`
while [ 1 ]; do
    datetime=$(date +%Y%m%d%H%M%S).pcap
    filepath=${currentpath}/${datetime}
    echo "file path is : ${filepath}"
     `tcpdump -i eth0 -w ${filepath}` &
    while [ 1 ];do
        dumppid=$!
        echo "dupmpid=${dumppid}"
        size=`stat -c "%s" ${filepath}`
        echo "file size:$size"
        if [ $size -gt 1000000 ]
        then
            echo "file size is large so break"
            kill -9 ${dumppid}
            break
        fi
        ls -l /proc/${dumppid}
        if [ $? -ne 0 ]
        then
            echo "tcp dump process not exist-----------------------------"
            break
        fi
        sleep 5
    done
done

