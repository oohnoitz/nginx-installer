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

# functions for patch application
function patch_enabled() {
	for i in ${PATCHES[@]} ; do
		if [ $i == ${1} ] ; then
			echo 1 # work-around, bash isn't accepting return value
			return 1
		fi
	done
	return 0
}

# functions for module installation
function module_enabled() {
	for i in ${MODULES[@]} ; do
		if [ $i == ${1} ] ; then
			echo 1 # work-around, bash isn't accepting return value
			return 1
		fi
	done
	return 0
}

function install_module() {
	if [ $(module_enabled "${1}") ] ; then
		echo -n "Downloading ${1} module... "
		wget -q --no-check-certificate "${2}" -O "modules/${1}.zip"
		if [ ! -s "modules/${1}.zip" ] ; then
			echo "Failed!"
			rm modules/${1}.zip
			echo "Skipping installation of ${1} module..."
		else
			echo "Done!"
			unzip modules/${1}.zip -d modules/${1}/
			module_source_directory=`find modules/${1}/* | head -1`
			CONFIGURE_PARAMS="${CONFIGURE_PARAMS} --add-module=${module_source_directory}"
		fi
	fi
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
if [ $(patch_enabled "spdy") ] ; then
	echo -n "Downloading Latest SPDY Patch... "
	wget -q http://nginx.org/patches/spdy/patch.spdy.txt -O patches/patch.spdy.txt
	if [ ! -s "patches/patch.spdy.txt" ] ; then
		echo "Failed!"
		rm patches/patch.spdy.txt
		echo "Skipping SPDY Patch..."
	else
		echo "Done!"
		echo "Patching ${NGINX_VERSION} with SPDY support..."
		patch -p1 < patches/patch.spdy.txt
		echo "Patched ${NGINX_VERSION} with SPDY support."
		CONFIGURE_PARAMS="${CONFIGURE_PARAMS} --with-http_spdy_module"
	fi
fi


# download and add modules to configure params
# +ngx_cache_purge - FRiCKLE
install_module "ngx_cache_purge" "https://github.com/FRiCKLE/ngx_cache_purge/zipball/master"
# +ngx_drizzle - chaoslawful
install_module "ngx_drizzle" "https://github.com/chaoslawful/drizzle-nginx-module/zipball/master"
# +ngx_echo - agentzh
install_module "ngx_echo" "https://github.com/agentzh/echo-nginx-module/zipball/master"
# +ngx_memc - agentzh
install_module "ngx_memc" "https://github.com/agentzh/memc-nginx-module/zipball/master"
# +ngx_mongo - simpl
install_module "ngx_mongo" "https://github.com/simpl/ngx_mongo/zipball/master"
# +ngx_postgres - FRiCKLE
install_module "ngx_postgres" "https://github.com/FRiCKLE/ngx_postgres/zipball/master"
# +ngx_redis2 - agentzh
install_module "ngx_redis2" "https://github.com/agentzh/redis2-nginx-module/zipball/master"
# +ngx_set_misc - agentzh
install_module "ngx_set_misc" "https://github.com/agentzh/set-misc-nginx-module/zipball/master"


echo "Configuring ${NGINX_VERSION}..."
./configure ${CONFIGURE_PARAMS}

echo "Compiling ${NGINX_VERSION}..."
make

echo "Installing ${NGINX_VERSION}..."
make install

echo "Starting ${NGINX_VERSION}..."
if [ ! -a "/etc/init.d/nginx" ] ; then
	echo "Error: You are missing the init script to start, stop, and restart nginx."
	exit 0
fi
/etc/init.d/nginx restart