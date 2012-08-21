#!/bin/bash
CONFIGURE_PARAMS="--with-debug --with-ipv6 --with-http_realip_module --with-http_ssl_module"
MODULES=("ngx_cache_purge")
PATCHES=("spdy")
WORKDIR="nginx"

# check if user is root and params are passed
[ $# -eq 0 ] && { echo "Usage: $0 <version>"; exit; }
if [[ $EUID -ne 0 ]] ; then
	echo "Error: This script must be run with root access to install nginx." 
	exit 1
fi

# misc functions
function installSource() {
	source=${2}
	for i in ${elements[@]} ; do
		if [ $i == $source ] ; then
			echo 1 # work-around
			return 1
		fi
	done
	return 0;
}

# clean-up work directory
NGINX_VERSION="nginx-${1}"
if [ -d "${WORKDIR}" ] ; then
	rm -Rf ${WORKDIR}
fi
mkdir ${WORKDIR}

# download source file
echo -n "Downloading ${NGINX_VERSION}... "
wget -q http://nginx.org/download/${NGINX_VERSION}.tar.gz -O ${WORKDIR}/nginx.tar.gz
if [ ! -s "${WORKDIR}/nginx.tar.gz" ] ; then
	echo "Failed!"
	rm -Rf ${WORKDIR}
	echo "Unable to locate the download file for ${NGINX_VERSION}.tar.gz on the servers."
	exit 1
fi
echo "Done!"

# extract and change directory to source
echo "Extracting ${NGINX_VERSION}..."
tar zxvf ${WORKDIR}/nginx.tar.gz -C ${WORKDIR}/
cd ${WORKDIR}/${NGINX_VERSION}/

# make folders to hold modules and patches
mkdir modules
mkdir patches

# download and apply patches
# ++spdy
if [ $(installSource "${PATCHES}" "spdy") ] ; then
	echo -n "Downloading Latest SPDY Patch... "
	wget -q http://nginx.org/patches/spdy/patch.spdy.txt -O patches/patch.spdy.txt
	if [ ! -s "patches/patch.spdy.txt" ] ; then
		echo "Failed!"
		rm patches/patch.spdy.txt
		echo "Skipping SPDY Patch..."
	else
		echo "Done!"
		echo "Patching ${NGINX_VERSION} with SPDY support..."
		patch -p0 < patches/patch.spdy.txt
		echo "Patched ${NGINX_VERSION} with SPDY support."
	fi
fi

# download and add modules to configure params
# ++ngx_cache_purge - FRiCKLE (https://github.com/FRiCKLE/ngx_cache_purge/)
if [ $(installSource "${MODULES}" "ngx_cache_purge") ] ; then
	echo -n "Downloading ngx_cache_purge module... "
	wget -q --no-check-certificate https://github.com/FRiCKLE/ngx_cache_purge/zipball/master -O modules/ngx_cache_purge.zip
	if [ ! -s "modules/ngx_cache_purge.zip" ]; then
		echo "Failed!"
		rm modules/ngx_cache_purge.zip
		echo "Skipping ngx_cache_purge module installation..."
	else
		echo "Done!"
		unzip modules/ngx_cache_purge.zip -d modules/ngx_cache_purge/
		module_ngx_cache_purge=`find modules/ngx_cache_purge/* | head -1`
		CONFIGURE_PARAMS="${CONFIGURE_PARAMS} --add-module=${module_ngx_cache_purge}"
	fi
fi

echo "Configuring ${NGINX_VERSION}..."
./configure ${CONFIGURE_PARAMS}

echo "Compiling ${NGINX_VERSION}..."
make

echo "Installing ${NGINX_VERSION}..."
make install

if [ -a "/etc/init.d/nginx" ] ; then
	echo "Starting ${NGINX_VERSION}..."
	/etc/init.d/nginx restart
else
	echo "Error: You are missing the init script to start, stop, and restart nginx."
fi