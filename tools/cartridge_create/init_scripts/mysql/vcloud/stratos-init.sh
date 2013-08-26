#!/bin/bash

# ----------------------------------------------------------------------------
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.

# ----------------------------------------------------------------------------
export LOG=/var/log/apache-cartridge.log
instance_path=/var/lib/cloud/instance
PUBLIC_IP=""
KEY=`uuidgen`
CRON_DURATION=1
RETRY_COUNT=30
SLEEP_DURATION=30

#if [ ! -d ${instance_path}/payload ]; then
#
#    echo "creating payload dir ... " >> $LOG
#    mkdir ${instance_path}/payload
#    echo "payload dir created ... " >> $LOG
#    cp ${instance_path}/user-data.txt ${instance_path}/payload/user-data.zip
#    echo "payload copied  ... "  >> $LOG
#    unzip -d ${instance_path}/payload ${instance_path}/payload/user-data.zip
#    echo "unzippeddd..." >> $LOG
#
#    for i in `/usr/bin/ruby /opt/get-launch-params.rb`
#    do
#    echo "exporting to bashrc $i ... " >> $LOG
#        echo "export" ${i} >> /home/ubuntu/.bashrc
#    done
#    source /home/ubuntu/.bashrc
    # Write a cronjob to execute apache-openstack-init.sh periodically until public ip is assigned
    #crontab -l > ./mycron
    #echo "*/${CRON_DURATION} * * * * /opt/apache-openstack-init.sh > /var/log/apache-openstack-init.log" >> ./mycron
    #crontab ./mycron
    #rm ./mycron

#fi

    for i in `/usr/bin/ruby /opt/get-launch-params.rb`
    do
    echo "exporting to bashrc $i ... " >> $LOG
        echo "export" ${i} >> /root/.bashrc
    done
    source /root/.bashrc

echo ---------------------------- >> $LOG
echo "getting private IP" >> $LOG

#wget http://169.254.169.254/latest/meta-data/public-ipv4
#files="`cat public-ipv4`"
#if [[ -z ${files} ]]; then
#    echo "getting public ip" >> $LOG
#    for i in {1..$RETRY_COUNT}
#    do
#      rm -f ./public-ipv4
#      wget http://169.254.169.254/latest/meta-data/public-ipv4
#      files="`cat public-ipv4`"
#      if [ -z $files ]; then
#          echo "Public ip is not yet assigned. Wait and continue for $i the time ..." >> $LOG
#          sleep $SLEEP_DURATION
#      else
#          echo "Public ip assigned" >> $LOG
          #crontab -r
#          break
#      fi
#    done

#    if [ -z $files ]; then
#      echo "Public ip is not yet assigned. So shutdown the instance and exit" >> $LOG
#      /sbin/poweroff
#      exit 0
#    fi
#    for x in $files
#    do
#        PUBLIC_IP="$x"
#    done


#else 
#   PUBLIC_IP="$files"
   #crontab -r
#fi
PUBLIC_IP=`ifconfig | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}'`

for i in `/usr/bin/ruby /opt/get-launch-params.rb`
do
    export ${i}
done

#PORTS=HTTP:8280:80|HTTPS:8243:443
#MYSQL_HOST
#MYSQL_USER
#MYSQL_PASSWORD
echo "Logging sys variables .. PUBLIC_IP:${PUBLIC_IP}, HOST_NAME:${HOST_NAME}, KEY:${KEY}, PORTS=${PORTS} , BAM:${BAM_IP}, GITREPO:${GIT_REPO}" >> $LOG


echo "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:agen=\"http://agent.cartridge.stratos.apache.org\">
  <soapenv:Header/>
  <soapenv:Body>
     <agen:register>
        <registrant> 
           <alarmingLowerRate>${ALARMING_LOWER_RATE}</alarmingLowerRate>
           <alarmingUpperRate>${ALARMING_UPPER_RATE}</alarmingUpperRate>
           <hostName>${HOST_NAME}</hostName>
           <key>${KEY}</key>
          <maxInstanceCount>${MAX}</maxInstanceCount>
	  <maxRequestsPerSecond>${MAX_REQUESTS_PER_SEC}</maxRequestsPerSecond>
          <minInstanceCount>${MIN}</minInstanceCount> " > /etc/agent/conf/request.xml

IFS='|' read -ra PT <<< "${PORTS}"
for i in "${PT[@]}"; do
IFS=':' read -ra PP <<< "$i"
echo "          <portMappings>
                        <primaryPort>${PP[1]}</primaryPort>
                        <proxyPort>${PP[2]}</proxyPort>
                        <type>${PP[0]}</type>
                </portMappings>">> /etc/agent/conf/request.xml
done

echo "          <remoteHost>${PUBLIC_IP}</remoteHost>
           <service>${SERVICE}</service>
	   <remoteHost>${PUBLIC_IP}</remoteHost>
           <roundsToAverage>${ROUNDS_TO_AVERAGE}</roundsToAverage>
           <scaleDownFactor>${SCALE_DOWN_FACTOR}</scaleDownFactor>
           <tenantRange>${TENANT_RANGE}</tenantRange>
        </registrant>
     </agen:register>
  </soapenv:Body>
</soapenv:Envelope>
" >> /etc/agent/conf/request.xml


echo "Sending register request to Cartridge agent service" >> $LOG

curl -X POST -H "Content-Type: text/xml" -d @/etc/agent/conf/request.xml --silent --output /dev/null "$CARTRIDGE_AGENT_EPR"

# ========================== // End of script ===========================================================