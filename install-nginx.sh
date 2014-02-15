#!/bin/bash

CONFIGURE_PARAMS="--with-debug --with-ipv6 --with-http_realip_module --with-http_ssl_module --with-http_spdy_module"
WORKDIR="nginx"

# is user root? are params passed?
[ $# -eq 0 ] && { echo "Usage: $0 <version>"; exit; }
if [[ $EUID -ne 0 ]] ; then
  echo "Error: This script must be run with root access to install nginx."
  exit 1
fi

# etc
NGINX_VERSION="nginx-${1}"
if [ -d "${WORKDIR}" ] ; then
  rm -Rf ${WORKDIR}
fi
mkdir -p ${WORKDIR}

# download source
echo -n "Downloading: ${NGINX_VERSION} ...   "
wget -q http://nginx.org/download/${NGINX_VERSION}.tar.gz -O ${WORKDIR}/nginx.tar.gz
if [ ! -s "${WORKDIR}/nginx.tar.gz" ] ; then
  rm -Rf ${WORKDIR}
  echo -e "[\e[0;31mFAILED\e[0m]"
  exit 1
fi
echo -e "[\e[0;32mDONE\e[0m]"

# extract
echo -n "Extracting:  ${NGINX_VERSION} ...   "
tar zxf ${WORKDIR}/nginx.tar.gz -C ${WORKDIR}/
echo -e "[\e[0;32mDONE\e[0m]"

# copy modules/patches
if [ -d "modules" ] ; then
  cp -R modules ${WORKDIR}/${NGINX_VERSION}
fi
if [ -d "patches" ] ; then
  cp -R patches ${WORKDIR}/${NGINX_VERSION}
fi

# enter directory
cd ${WORKDIR}/${NGINX_VERSION}

# install extra stuff
function install_extra() {
  if [ -d ${1} ] ; then
    echo "lol"
    for file in ${1}/* ; do
      if [ ${1} == "modules" ] ; then
        unzip $file -d ${1}/$(basename $file ".zip")
        MODULE=`find ${1}/$(basename $file ".zip")/* | head -1`
        CONFIGURE_PARAMS="${CONFIGURE_PARAMS} --add-module=${MODULE}"
      fi

      if [ ${1} == "patches" ] ; then
        echo "Applying Patch: $(basename $file)"
        patch -p1 < $file
      fi
    done
  fi
}

install_extra "modules"
install_extra "patches"

# configure
echo "Configuring..."
./configure ${CONFIGURE_PARAMS}

echo "Compiling..."
make

echo "Installing..."
make install

echo "Finished!"
