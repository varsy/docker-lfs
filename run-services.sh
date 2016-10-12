#!/bin/bash

rccheck() {
   if [[ $? != 0 ]]; then
      echo "Error! Stopping the script."
      exit 1
   fi
}

if [ ! -f /root/logFacesServer/conf/lfs.xml ];
then
   echo "Looks like it is the first run of the lfs service"
   echo -n "Generating configs... " ; /root/logFacesServer/bin/lfs start > /dev/null 2>&1 ; rccheck
   while [ ! -f /root/logFacesServer/conf/lfs.xml ];
   do
      sleep 2
   done
   /root/logFacesServer/bin/lfs stop > /dev/null 2>&1 ; rccheck ; echo "done!"
fi

if [ -f /conf/lfs.xml ]; then
   echo -n "Setting our configs instead of typical... "

   rm -rf /root/logFacesServer/db/ ; rccheck
   if [ ! -f /root/logFacesServer/conf/hosts.properties ]; then
      touch /root/logFacesServer/conf/hosts.properties ; rccheck
   fi
   for i in `find /conf/ -type f`; do ln -fs $i /root/logFacesServer/conf/ ; done
   echo "done!"

   echo -n "Adding truststore to environment.properties... "
   sed -i --follow-symlinks 's|com.moonlit.logfaces.security.trustStore =.*|com.moonlit.logfaces.security.trustStore = ${lfs.home}/conf/lfs.truststore|' /root/logFacesServer/conf/environment.properties
   sed -i --follow-symlinks 's/com.moonlit.logfaces.security.trustPass.*/com.moonlit.logfaces.security.trustPass = OBF:1vn21ugu1saj1v9i1v941sar1ugw1vo0/' /root/logFacesServer/conf/environment.properties
   echo "done!"
fi

if [ ${MONGO_URL} ]; 
then
   sed -i --follow-symlinks 's/com.moonlit.logfaces.config.mongodb=.*/com.moonlit.logfaces.config.mongodb=true/' /root/logFacesServer/conf/environment.properties
   sed -i --follow-symlinks "s/com.moonlit.logfaces.config.mongodb.connection =.*/com.moonlit.logfaces.config.mongodb.connection=${MONGO_URL}/" /root/logFacesServer/conf/mongodb.properties

   sed -i --follow-symlinks 's/^com.moonlit.logfaces.config.mongodb.dbname  =.*/com.moonlit.logfaces.config.mongodb.dbname  = lfsp/' /root/logFacesServer/conf/mongodb.properties
   sed -i --follow-symlinks 's/^com.moonlit.logfaces.config.mongodb.ttlDays =.*/com.moonlit.logfaces.config.mongodb.ttlDays = 0/' /root/logFacesServer/conf/mongodb.properties
   sed -i --follow-symlinks 's/^com.moonlit.logfaces.config.mongodb.partitioned =.*/com.moonlit.logfaces.config.mongodb.partitioned = true/' /root/logFacesServer/conf/mongodb.properties
   sed -i --follow-symlinks 's/^com.moonlit.logfaces.config.mongodb.pdays =.*/com.moonlit.logfaces.config.mongodb.pdays = 1/' /root/logFacesServer/conf/mongodb.properties
fi

trap "/root/logFacesServer/bin/lfs stop" SIGINT SIGTERM SIGHUP
/root/logFacesServer/bin/lfs console &
wait
