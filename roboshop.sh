#!/bin/bash
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0ffa720383ab81b60"
Subnet_ID="subnet-07d3df42f412ee2cf"
INSANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "payment" "user" "cart" "shipping" "dispatch" "frontend")
ZONE_ID="Z0824281I9NY5JEKLS4"
DOMAIN_ID="tejaswini.site"

for instance in ${INSTANCES[@]}
do
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-09c813fb71547fc4f \
    --instance-type t3.micro \
    --subnet-id subnet-07d3df42f412ee2cf \
    --security-group-ids sg-0ffa720383ab81b60 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" \
    --query "Instances[0].InstanceId"\
    --  output text)
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
     echo "$instance IP address: $IP"

done