#!/bin/bash

WORKDIR="modules"

[ $# -eq 0 ] && { echo "Usage: $0 <module>"; exit; }
if [[ $EUID -ne 0 ]] ; then
  echo "Error: This script must be run with root access to install nginx."
  exit 1
fi

function download_module() {
  link=""
  case "${1}" in
    ngx_cache_purge)
      link="https://github.com/FRiCKLE/ngx_cache_purge/zipball/master"
      ;;
    ngx_devel_kit)
      link="https://github.com/simpl/ngx_devel_kit/archive/master"
      ;;
    ngx_drizzle)
      link="https://github.com/chaoslawful/drizzle-nginx-module/zipball/master"
      ;;
    ngx_echo)
      link="https://github.com/agentzh/echo-nginx-module/zipball/master"
      ;;
    ngx_ench_memcache)
      link="https://github.com/bpaquet/ngx_http_enhanced_memcached_module/archive/master"
      ;;
    ngx_headers_more)
      link="https://github.com/openresty/headers-more-nginx-module/archive/master"
      ;;
    ngx_memc)
      link="https://github.com/agentzh/memc-nginx-module/zipball/master"
      ;;
    ngx_mod_zip)
      link="https://github.com/evanmiller/mod_zip/archive/master"
      ;;
    ngx_mongo)
      link="https://github.com/simpl/ngx_mongo/zipball/master"
      ;;
    ngx_postgres)
      link="https://github.com/FRiCKLE/ngx_postgres/zipball/master"
      ;;
    ngx_redis2)
      link="https://github.com/agentzh/redis2-nginx-module/zipball/master"
      ;;
    ngx_rtmp)
      link="https://github.com/arut/nginx-rtmp-module/zipball/master"
      ;;
    ngx_set_misc)
      link="https://github.com/agentzh/set-misc-nginx-module/zipball/master"
      ;;
    ngx_sphinx2_search)
      link="https://github.com/reeteshranjan/sphinx2-nginx-module/archive/master"
      ;;
    *)
      echo "Error: Invalid Module"
      exit 1
      ;;
  esac

  mkdir -p ${WORKDIR}
  echo -n "Downloading: ${1} ...   "
  wget -q --no-check-certificate ${link} -O "${WORKDIR}/${1}.zip"
  if [ ! -s "${WORKDIR}/${1}.zip" ] ; then
    rm ${WORKDIR}/${1}.zip
    echo -e "[\e[0;31mFAILED\e[0m]"
  else
    echo -e "[\e[0;32mDONE\e[0m]"
  fi
}

download_module ${1}
