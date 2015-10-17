#
# Oracle Java 7 Dockerfile
#
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/oracle-java7
#

# Pull base image.
FROM ubuntu:14.04

MAINTAINER wakaru44@gmail.com
LABEL Description="This image is a test to run minecraft inside a container"

COPY run.sh . 
#RUN ping -c 2 172.17.42.1
#RUN route -n

###
# Install Java.
###RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf
###RUN cat /etc/resolv.conf
###RUN ifconfig
###RUN ping -c 2 8.8.8.8
RUN apt-get update
RUN apt-get install -y software-properties-common
# Installing step by step
RUN  echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN  add-apt-repository -y ppa:webupd8team/java 
RUN apt-get update
RUN  apt-get install -y oracle-java7-installer
#RUN  apt-get install -y oracle-java7-installer
RUN  rm -rf /var/lib/apt/lists/*
RUN  rm -rf /var/cache/oracle-jdk7-installer

###RUN \
###  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
###  add-apt-repository -y ppa:webupd8team/java && \
###  apt-get install -y oracle-java7-installer && \
###  rm -rf /var/lib/apt/lists/* && \
###  rm -rf /var/cache/oracle-jdk7-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle


# Replace 1000 with your user / group id
# as to run GUI apps we will need the GUIs to match

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

ENV HOME /home/${USER:-developer}

# Some minecraft dependencies
RUN apt-get update
RUN apt-get install -y libxtst6 libxrender1 libxi6


#### Define working directory.
####WORKDIR /data
####VOLUME ["${HOME}"]
###RUN ls -l ${HOME}
###RUN mkdir -p ${HOME}/tmp
###RUN file ${HOME}/tmp
###
#### get the minecraft package from somewhere
####ADD https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar ${HOME}
####WHY: the add from remote tries to write on /home/developer/tmp
###
###
###CMD java -jar Minecraft.jar

ENV DISPLAY=:0
VOLUME  /tmp/.X11-unix
WORKDIR $HOME
RUN file $HOME
VOLUME /home/wakaru/.Xauthority:/home/developer/.Xauthority
USER developer
ADD Minecraft.jar ./
ADD run.sh ./
CMD /bin/bash /home/developer/run.sh
