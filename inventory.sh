#!/bin/bash

echo "Server : "$(hostname -f)

ncpu=$(( $(cat /proc/cpuinfo |grep "physical id"|tail -n 1|sed 's/.*: //') + 1 ))
cpumodel=$(cat /proc/cpuinfo |grep "model name"|head -n 1|sed 's/.*CPU //')
cpucores=$(cat /proc/cpuinfo |grep "cpu cores"|head -n 1|sed 's/.*: //')

echo "CPU = "$ncpu"*"$cpumodel" "$cpucores"C"
echo "RAM = $(free -g | tail -n +2| head -n1 |awk '{print $2}')Go"

for d in $(ls /dev/sd*|grep -vE "[0-9]")
do
  capacity=$(hdparm -I $d | grep "device size with M = 1000.1000"|sed 's/.*MBytes //'| tr -d '()')
  type=$(hdparm -I $d | grep "Nominal Media Rotation Rate: Solid State Device" > /dev/null && echo "SSD" || echo "HDD" )
  echo "DSK = SATA $d $type $capacity"
done 

echo "IPLIST = $(ip a|grep "inet " | awk '{print $2}')"
