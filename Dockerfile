FROM sergeyzh/centos6-java
MAINTAINER Andrey Sizov, andrey.sizov@jetbrains.com

ENV LFS_VERSION 4.2.1

ADD http://www.moonlit-software.com/logfaces/downloads/lfs.${LFS_VERSION}.linux.x86-64.tar.gz /root/
RUN tar zxf /root/lfs.${LFS_VERSION}.linux.x86-64.tar.gz -C /root/

RUN sed -i '1 a JAVA_HOME=/usr/java64/current' /root/logFacesServer/bin/lfs
RUN sed -i '2 a APP_BIN=/root/logFacesServer/bin' /root/logFacesServer/bin/lfs
RUN sed -i 's/WRAPPER_CMD=\"\./WRAPPER_CMD=\"\$\{APP_BIN\}/' /root/logFacesServer/bin/lfs
RUN sed -i 's/WRAPPER_CONF=\"\./WRAPPER_CONF=\"\$\{APP_BIN\}/' /root/logFacesServer/bin/lfs

ENV JAVA_HOME /usr/java64/current
ENV PATH $PATH:$JAVA_HOME/bin

ADD run-services.sh /
RUN chmod +x /run-services.sh
CMD /run-services.sh

EXPOSE 8050 55200 1468 55201 514
