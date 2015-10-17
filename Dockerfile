#
# Oracle Java 7 Dockerfile
#
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/oracle-java7
#

MAINTAINER wakaru44@gmail.com
LABEL Description="This image is a test to run minecraft inside a container"

# Pull base image.
FROM dockerfile/ubuntu:14.04

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

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


# Define working directory.
#WORKDIR /data
#VOLUME ["${HOME}"]
RUN ls -l ${HOME}
RUN mkdir -p ${HOME}/tmp
RUN file ${HOME}/tmp
WORKDIR $HOME

# get the minecraft package from somewhere
#ADD https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar ${HOME} #WHY: the add from remote tries to write on /home/developer/tmp
COPY Minecraft.jar .


USER developer
CMD java -jar Minecraft.jar


# Define default command.
#CMD ["bash"]
