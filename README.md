# Open Auto Pro Docker

Note: It's still work in progress. Right now the GUI launches but OAP can't interact with the outside world so it's useless right now.


## Terms used

- OAP - Open Auto Pro, an abandoned OS by BlueWaveStudio we want to run in a Docker container
- Primary OS - an official OAP system image running Raspberry Pi OS Buster with armhf(32bit) architecture.
- Target OS - the system you want to eventually run your headunit on. My target OS during development of this project is the same as the primary OS but my goal is to run it on the latest Raspberry Pi OS arm64.

## Getting started

Usually when people package apps in Docker containers, they upload the prebuilt images to Dockerhub. I'm not going to do that because that would be redistribution of proprietary software I don't have copyright for.

Therefore this is what you need to do:
 1. Obtain a legal copy of OAP and run it on a compatible Raspberry Pi
 2. Install docker on the primary OS
 3. Run the following commands:
 ```sh
git clone https://github.com/igoro00/oap-docker.git
cd oap-docker
./setup.sh # copies OAP files and builds the image
```
 4. If your target OS is different than your primary OS:
    - Export your container image: 
    ```sh
    docker save oap | gzip | pv > oap-docker.tar.gz
    ```
    - Move `/home/pi/oap-docker/oap-docker.tar.gz` file to your target OS
    - Install docker on the target OS
    - Import your container image on the target OS:
    ```sh
    docker load < oap-docker.tar.gz 
    ```
5. Run the container:
```sh
# allow access to host's X11
xhost +local:docker

# use default X11 DISPLAY, only needed if you run this through ssh
export DISPLAY=:0

docker run --rm -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e PULSE_SERVER=unix:/tmp/pulse-socket \
    -v $XDG_RUNTIME_DIR/pulse/native:/tmp/pulse-socket \
    --device /dev/snd \
    --group-add audio \
    oap-docker
```


## Install docker

Install Docker using the [official instructions](https://docs.docker.com/engine/install/raspberry-pi-os/) for your OS.

As of July 2025, while the docs say it only supports Raspberry Pi OS bullseye, bookworm and trixie, it appears they also support buster.

Next you have to fix the permissions so you don't have to use `sudo` all the time when dealing with docker ([source](https://stackoverflow.com/a/48957722)):
```sh
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

If you get this error while interacting with docker:
`Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?` then you need to start docker service:
```sh
sudo systemctl enable --now docker
```

