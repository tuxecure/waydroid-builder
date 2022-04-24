#!/bin/bash
# build waydroid for debian or ubuntu v4
# date  : 2022-04-08
# author: Wachid Adi Nugroho <wachidadinugroho.maya@gmail.com>

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

repos=(
  "https://github.com/sailfishos/libglibutil.git"
  "https://github.com/mer-hybris/libgbinder.git"
  "https://github.com/waydroid/gbinder-python.git"
  "https://github.com/waydroid/waydroid.git"
)
for i in ${repos[@]}
do
  url=${i}
  i=${i%*.git}; i=${i##*\/}
  echo -e "${GREEN}==========> Start building ${i} <==========${NC}"
  echo -e "${GREEN}==> Cloning git repository ${i} ...${NC}"
  git clone "${url}"
  echo -e "${GREEN}==> Cloning git repository ${i}, done.${NC}\n"
  cd "${i}"
  echo 12 > debian/compat
  if [ ! -f debian/changelog ]; then
    echo -e "${GREEN}==> Building changelog ${i} ...${NC}"
    /build_changelog
    echo -e "${GREEN}==> Building changelog ${i}, done.${NC}\n"
  fi
  echo -e "${GREEN}==> Building dependencies ...${NC}"
  mk-build-deps -ir -t "apt-get -o Debug::pkgProblemResolver=yes -y --no-install-recommends"
  echo -e "${GREEN}==> Building dependencies, done...${NC}\n"
  echo -e "${GREEN}==> Building package: ${i} ...${NC}"
  debuild -b -uc -us
  echo -e "${GREEN}==> Building package: ${i}, done.${NC}\n"
  echo -e "${GREEN}==> Installing packages ...${NC}"
  ls
  apt-get install -y ./*.deb && \
  echo -e "${GREEN}==> Installing ${i} packages success${NC}"|| exit 1
  mv *.deb packages 2> /dev/null
  mv *.ddeb packages 2> /dev/null
  rm -rf ${i}
  echo -e "${GREEN}==========> Done building ${i} <==========${NC}\n"
done

echo -e "${GREEN}==> Packages archive saved in /waydroid-packages/packages/${NC}"
ls -1 /waydroid-packages/packages/
echo
rm -f /waydroid-packages/*.* 2> /dev/null
