#!/bin/bash
#Commands to install AWS CodeDeploy
echo "Starting the process to install AWS CodeDeploy.."
yum install ruby -y
aws s3 cp s3://aws-codedeploy-us-west-2/latest/install /opt/ --region us-west-2
cd /opt/ && chmod +x ./install
./install auto
service codedeploy-agent start
PROCESS=$(ps -ef | grep -i codedeploy | grep -v grep | wc -l)
if [ ${PROCESS} -ge 1 ];
 then
  echo "CodeDeploy is installed and running!"
else
  echo "CodeDeploy is not running! Please troubleshoot!"
fi
echo "All done!"
