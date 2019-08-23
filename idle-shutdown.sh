#!/bin/bash
# requires `bc`,some Linux already preinstalled, if not -> sudo apt-get install bc
# Modified from http://rohitrawat.com/automatically-shutting-down-google-cloud-platform-instance
threshold=0.1

count=0
wait_minutes=60
while true
do

  load=$(uptime | sed -e 's/.*load average: //g' | awk '{ print $1 }') # 1-minute average load
  # echo "Load1: $load" 
  load="${load//,}" # remove trailing comma
  # echo "Load2 $load" >> /home/test.txt

  procn=$(nproc) # the number of processors
  # echo "Proc $procn"  >> /home/test.txt

  load=$(echo "$load/$procn" | bc -l)
  echo "Load $load"  >> /home/test.txt

  res=$(echo "$load"'<'$threshold | bc -l)
  
  echo "Res $res" >> /home/test.txt
  if (( res ))
  then
    ((count+=1))
    echo "Idling.. $count"  >> /home/test.txt
  else
    count=0
  fi
  # echo "Idle minutes count = $count" >> /home/test.txt

  if (( count>wait_minutes ))
  then
    echo Shutting down >> /home/test.txt
    sleep 180
    sudo poweroff -h
  fi

  sleep 60

done
