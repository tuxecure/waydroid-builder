FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential cdbs devscripts equivs fakeroot git git-lfs git-buildpackage #debhelper
RUN wget -O /build_changelog https://raw.githubusercontent.com/MrCyjaneK/waydroid-build/main/build_changelog
RUN chmod +x /build_changelog

COPY build-waydroid-for-debian-or-ubuntu-v4.sh /build-waydroid-for-debian-or-ubuntu-v4.sh
RUN chmod +x /build-waydroid-for-debian-or-ubuntu-v4.sh

WORKDIR /waydroid-packages
VOLUME /waydroid-packages
ENTRYPOINT ["/build-waydroid-for-debian-or-ubuntu-v4.sh"]
