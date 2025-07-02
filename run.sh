# use default X11 DISPLAY, only needed if you run this through ssh
export DISPLAY=:0

# allow access to host's X11
xhost +local:docker

docker run --rm -it \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -v $XDG_RUNTIME_DIR/pulse/native:$XDG_RUNTIME_DIR/pulse/native \
    -v $XDG_RUNTIME_DIR/pulse/dbus-socket:$XDG_RUNTIME_DIR/pulse/dbus-socket \
    -e DBUS_SESSION_BUS_ADDRESS=$XDG_RUNTIME_DIR/bus \
    -v $XDG_RUNTIME_DIR/bus:$XDG_RUNTIME_DIR/bus \
    --device /dev/snd \
    --group-add audio \
    oap-docker

xhost -local:docker