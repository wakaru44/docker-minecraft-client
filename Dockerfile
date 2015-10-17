FROM java:7
#FROM ubuntu:14.04
MAINTAINER wakaru44@gmail.com
LABEL Description="This image is a test to run minecraft inside a container"

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

#VOLUME ["${HOME}"]
RUN ls -l ${HOME}
RUN mkdir -p ${HOME}/tmp/bonkers
RUN file ${HOME}/tmp/bonkers
WORKDIR $HOME

# get the minecraft package from somewhere
#ADD https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar ${HOME} #WHY: the add from remote tries to write on /home/developer/tmp
COPY Minecraft.jar .


# TODO: install java from oracle

USER developer
CMD java -jar Minecraft.jar

