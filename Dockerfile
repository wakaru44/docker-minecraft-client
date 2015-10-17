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

###
# Install Java.
RUN apt-get update
RUN apt-get install -y software-properties-common
# Installing step by step
RUN  echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN  add-apt-repository -y ppa:webupd8team/java 
RUN  apt-get update
RUN  apt-get install -y oracle-java7-installer
RUN  rm -rf /var/lib/apt/lists/*
RUN  rm -rf /var/cache/oracle-jdk7-installer

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


# get the minecraft package from somewhere
#ADD https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar ${HOME}
#WHY: the add from remote tries to write on /home/developer/tmp

# Configure variables 

#ENV DISPLAY=:0 # not needed here, as is better to run from command line
#VOLUME  /tmp/.X11-unix # It doesn't work when specified here, has to be from command line
#VOLUME /home/wakaru/.Xauthority:/home/developer/.Xauthority  # It doesn't work when specified here, has to be from command line 
USER developer
WORKDIR $HOME
RUN file $HOME
COPY Minecraft.jar ./
#Why the file is added as root?
COPY run.sh ./ 
RUN ls -lart
RUN sudo chown -R developer:developer .
CMD /bin/bash ./run.sh
