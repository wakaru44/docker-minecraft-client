# Minecraft Container

to run a java gui app from a container

## Installing

- get the dockerfile and other stuff by cloning the repo

        git clone https://github.com/wakaru44/docker-minecraft-client.git

- get the Minecraft.jar from the minecraft page 

        cd docker-minecraft-client
        wget https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar

- build the image 

        docker build -t minecraft .

## Running it

- run it like in `running_container.sh` says, sharing volumes and stuff


        docker run -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix  -v /home/wakaru/.Xauthority:/home/developer/.Xauthority --net=host minecraft

REMEMBER: You will need the Minecraft.jar downloaded in this same folder
