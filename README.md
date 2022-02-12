# What it does

* This is a CloudFormation template for running batches in ECS. 
* There are three CloudFormation templates: 1) for Building Cluster and 2) for Register tasks for batch（two types）.
* There is a script to run ECS tasks as a batch and a script to check task status.


## Deployment

Deployments using Cloudformation templates target ECS (Cluster, Task), IAM related to ECS, SecurityGroup, EFS releated to ECS.

### Prerequisites

* The container image required to run the batch must be registered. 
* EFS provisioning to persist scripts, logs, etc. needed by the batch and scripts to be executed by the batch should be stored in that area. 

## Usage

### ECS Deploy(Cluster,Task)
    [Cluster]
    aws cloudformation deploy --template-file mkecs-simbatch-cluster.yaml --stack-name sim-batch-cluster-sn --capabilities CAPABILITY_NAMED_IAM
    
    [Tasks]
    aws cloudformation deploy --template-file run-simbatch-auditquery.yaml --stack-name sim-batch-task-adqy-sn --capabilities CAPABILITY_NAMED_IAM

    aws cloudformation deploy --template-file run-simbatch-pgimport.yaml --stack-name sim-batch-task-pgimp-sn --capabilities CAPABILITY_NAMED_IAM
    

    ### Batch execution / Batch status check
    ./execEcsTask.sh [IAMPROFILE] [ClusterName] [TaskArnWildCard : ex) MKECS_SIM-BATCH-AUDITQUERY] [ECS-TARGET-SUBNET]

      This script can run only the latest revision of the ECS task. 
 
    ./getSimbatchTaskStatus.sh [IAMPROFILE] [ClusterName]

