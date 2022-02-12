#!/bin/bash

if [ $# -ne 2 ];then
   echo "./getSimbatchTaskStatus.sh [IAMPROFILE] [ClusterName]"
   exit 2
fi

PROFILE=$1
CLUSTER=$2

TASKARN=`cat /tmp/taskarn`
TASKNUM=`cat /tmp/taskarn | awk -F'\/' '{print $3}'`
TCLS=`aws ecs describe-tasks --profile $CLUSTER --cluster $CLUSTER --tasks $TASKARN | jq '.tasks[].containers[].lastStatus'`
TD=`aws ecs describe-tasks --profile $CLUSTER --cluster $CLUSTER --tasks $TASKARN | jq '.tasks[].desiredStatus'`
TL=`aws ecs describe-tasks --profile $CLUSTER --cluster $CLUSTER --tasks $TASKARN | jq '.tasks[].lastStatus'`
TS=`aws ecs describe-tasks --profile $CLUSTER --cluster $CLUSTER --tasks $TASKARN | jq '.tasks[].stopCode'`
TSR=`aws ecs describe-tasks --profile $CLUSTER --cluster $CLUSTER --tasks $TASKARN | jq '.tasks[].stoppedReason'`
MSG=`aws logs get-log-events --profile $CLUSTER --log-group-name /ecs/$CLUSTER --log-stream-name simbatch/simbatch/$TASKNUM | jq '.events[].message'`

echo "Container LAST STATUS: $TCLS"
echo "Disired Status: $TD" 
echo "LAST Status: $TL" 
echo "StopCode: $TS" 
echo "StoppedReason: $TSR" 
echo "Message: $MSG"
