#!/bin/bash
# script name: build_waydroid_v5.sh
# description: Build Waydroid for Debian or Ubuntu based distro v5
# upstream   : https://gist.github.com/cniw/98e204d7dbc73a3fa1bf61629b2a2fc1
# author     : Wachid Adi Nugroho <wachidadinugroho.maya@gmail.com>
# date       : 2022-05-11

NC='\033[0m'
RED='\033[1;91m'
GREEN='\033[1;92m'

repos=(
  "https://github.com/sailfishos/libglibutil.git"
  "https://github.com/mer-hybris/libgbinder.git"
  "https://github.com/waydroid/gbinder-python.git"
  "https://github.com/waydroid/waydroid.git"
)
mkdir packages
for i in ${repos[@]}
do
  url=${i}
  i=${i%*.git}; i=${i##*\/}
  echo -e "${GREEN}==========> Start preparing ${i} <==========${NC}"
  echo -e "${GREEN}==> Cloning git repository ${i} ...${NC}"
  [ -d ${i} ] && sudo rm -rf "${i}"
  git clone "${url}" || exit 1
  echo -e "${GREEN}==> Cloning git repository ${i}, done.${NC}\n"

  cd "${i}"
  echo 12 > debian/compat
  if [ ! -f debian/changelog ]; then
    echo -e "${GREEN}==> Building changelog ${i} ...${NC}"
    /build_changelog || exit 1
    echo -e "${GREEN}==> Building changelog ${i}, done.${NC}\n"
  fi

  echo -e "${GREEN}==> Installing build dependencies for ${i} ...${NC}"
  mk-build-deps -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y --no-install-recommends" || exit 1
  echo -e "${GREEN}==> Installing build dependencies for ${i}, done.${NC}"
  echo -e "${GREEN}==========> Finish preparing ${i} <==========${NC}\n"

  echo -e "${GREEN}==========> Start building ${i} <==========${NC}"
  echo -e "${GREEN}==> Building package(s): ${i} ...${NC}"
  debuild -b -uc -us
  if [ ! $? -eq 0 ]
  then
    echo -e "\n${RED}==> Building package(s): ${i}, failed.${NC}\n"
    exit 1
  else
    echo -e "${GREEN}==> Building package(s): ${i}, done.${NC}"
    echo -e "${GREEN}==========> Finish building ${i} <==========${NC}\n"

    echo -e "${GREEN}==========> Start installing ${i} <==========${NC}"
    echo -e "${GREEN}==> Installing package(s): ${i} ...${NC}"
    cd ..
    apt-get install ./*.deb
    if [ ! $? -eq 0 ]
    then
      echo -e "${RED}==> Installing ${i}, error.${NC}"
      echo -e "${GREEN}==> Trying to fix it ...${NC}"
      apt-get install -f -y || exit 1
      echo -e "${GREEN}==> Fixed.${NC}"
    fi
    echo -e "${GREEN}==> Installing ${i}, success.${NC}"
    echo -e "${GREEN}==> Installing package(s): ${i}, done.${NC}"
    echo -e "${GREEN}==========> Finish installing ${i} <==========${NC}\n"

    mv *.deb packages 2> /dev/null
    mv *.ddeb packages 2> /dev/null
    rm -rf ${i}
  fi
done

echo -e "${GREEN}==> Successfully build and installing all packages${NC}"
echo -e "${GREEN}==> Packages archive saved in $(realpath ~)/waydroid-build/packages/${NC}"
ls -1 packages/
echo
sudo rm -f *.*  /build_changelog 2> /dev/null
