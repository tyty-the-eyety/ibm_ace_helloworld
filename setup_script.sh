#!/bin/bash

# source mqsiprofile           
. /opt/ibm/ace-12/server/bin/mqsiprofile
           
# Print commands to the screen
set -x

# Exit on any error
set -e

echo "================ create workpath for integration server ================"
mqsicreateworkdir /var/mqsi/integration_server/HelloWorld
echo "================ create workpath for integration server ================"
cp /tmp/code/config/server.conf.yaml /var/mqsi/integration_server/HelloWorld/server.conf.yaml
cd /tmp/code
echo "================ use ibmint to create and deploy bar file ================"
ibmint deploy --input-path $PWD --output-work-directory /var/mqsi/integration_server/HelloWorld --project Hello_World_APP --trace trace.txt
echo "================ start the Integration Server  ================"
IntegrationServer -w /var/mqsi/integration_server/HelloWorld --no-nodejs | tee logs.txt
echo "================ check logs file for error  ================"
if $(cat test1.txt | grep -q "org.opentest4j.AssertionFailedError"); then
    echo "found org.opentest4j.AssertionFailedError"
    exit -1
fi   
echo "================ Integration Server Started  ================"
ls -la 