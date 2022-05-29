FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential cdbs devscripts equivs fakeroot git git-lfs git-buildpackage libgbinder-dev #debhelper
RUN wget -O /build_changelog https://raw.githubusercontent.com/MrCyjaneK/waydroid-build/main/build_changelog
RUN chmod +x /build_changelog

COPY build_waydroid_v5.sh /build_waydroid_v5.sh
RUN chmod +x /build_waydroid_v5.sh

WORKDIR /waydroid-packages
VOLUME /waydroid-packages
ENTRYPOINT ["/build_waydroid_v5.sh"]
