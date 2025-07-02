FROM debian:buster

RUN apt update
RUN apt install -y ca-certificates apt-listchanges
RUN rm -rf /etc/apt/*
COPY build/src/etc/apt /etc/apt

# Install dependencies
RUN apt-get clean && apt-get update && apt-get upgrade -y

# this list was created by:
# 1. running /usr/local/bin/autoapp in the container
# 2. getting error: "error while loading shared libraries: <file>"
# 3. looking up the package in the host system with `dpkg -S <file>`
# 4. adding the package to the list below
# 6. rebuilding image
# 7. repeat until no more errors
RUN apt-get update && apt-get install -y \
x11-apps \
pulseaudio \
libgl1 \
dbus-x11 \
libboost-all-dev \
libusb-1.0-0 \
libprotobuf17 \
libxdo3 \
libqt5core5a \
libqt5dbus5 \
libqt5xmlpatterns5 \
libmusicbrainz5-2 \
libcoverart1 \
libgps23 \
libi2c0 \
libkf5bluezqt6 \
libqt5quick5 \
libqt5x11extras5 \
libqt5multimediawidgets5 \
librtlsdr0 \
qml-module-qtquick-controls \
qml-module-qtquick-privatewidgets \
qml-module-qt-labs-settings \
qml-module-qtcharts \
qml-module-qtmultimedia \
qml-module-qtquick-controls2 \
qml-module-qtquick-dialogs

# WHYYYYYYY????
ADD https://old-releases.ubuntu.com/ubuntu/pool/main/libq/libqofono/libqofono-dev_0.90+16.10.20160901-0ubuntu1_armhf.deb /tmp/libqofono-dev.deb
ADD https://old-releases.ubuntu.com/ubuntu/pool/main/libq/libqofono/libqofono-qt5-0_0.90+16.10.20160901-0ubuntu1_armhf.deb /tmp/libqofono-qt5-0.deb
RUN dpkg -i /tmp/libqofono-dev.deb /tmp/libqofono-qt5-0.deb
RUN rm /tmp/libqofono-dev.deb /tmp/libqofono-qt5-0.deb

# Create pi user
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g $GROUP_ID pi
RUN useradd -m -u $USER_ID -g $GROUP_ID pi

ENV HOME=/home/pi
WORKDIR /home/pi
RUN mkdir -p /home/pi/.openauto
    
COPY --chown=root:root build/src/usr/local/bin/autoapp /usr/local/bin/autoapp
COPY --chown=root:root build/src/usr/local/lib/libaasdk.so /usr/local/lib/libaasdk.so
COPY --chown=root:root build/src/usr/local/lib/libaasdk_proto.so /usr/local/lib/libaasdk_proto.so
COPY --chown=pi:pi build/src/home/pi/.openauto /home/pi/.openauto
    
RUN ldconfig

USER pi

CMD ["/usr/local/bin/autoapp"]