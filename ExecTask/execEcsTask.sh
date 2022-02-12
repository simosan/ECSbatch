#!/bin/bash

if [ $# -ne 4 ];then
   echo "./execEcsTask.sh [IAMPROFILE] [ClusterName] [TaskArnWildCard :  ex) MKECS_SIM-BATCH-AUDITQUERY] [ECS-TARGET-SUBNET]"
   exit 2
fi

PROFILE=$1
CLUSTER=$2
TASKARN=$3
SUBNET=$4

ARN=`aws ecs list-task-definitions --profile $PROFILE | jq '.taskDefinitionArns[]' | sed 's/\"//g'`
for i in `echo $ARN`
do
   if [[ $i == *"$TASKARN"* ]];then
      ARN=$i
      echo $ARN
      break
   fi
done
SG=`aws ec2 describe-security-groups --profile $PROFILE --filters Name='group-name',Values=$CLUSTER | jq '.SecurityGroups[].GroupId' | sed 's/\"//g'`
export AWS_PAGER="";aws ecs run-task --profile $PROFILE --cluster $CLUSTER --enable-execute-command --task-definition $ARN --network-configuration "awsvpcConfiguration={subnets=[$SUBNET],securityGroups=[$SG],assignPublicIp=DISABLED}" --launch-type FARGATE | jq '.tasks[].taskArn' | sed 's/\"//g' > /tmp/taskarn

