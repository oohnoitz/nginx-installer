#!/bin/bash

WORKDIR="modules"

which git &> /dev/null
if [ $? -ne 0 ] ; then
  echo "Error: This script requires 'git' to be installed on the system."
  exit 1
fi

function fetch() {
  repo=""
  case "${1}" in
    ngx_brotli)
      repo="https://github.com/google/ngx_brotli.git"
      ;;
    ngx_cache_purge)
      repo="https://github.com/FRiCKLE/ngx_cache_purge.git"
      ;;
    ngx_devel_kit)
      repo="https://github.com/simpl/ngx_devel_kit.git"
      ;;
    ngx_drizzle)
      repo="https://github.com/chaoslawful/drizzle-nginx-module.git"
      ;;
    ngx_echo)
      repo="https://github.com/agentzh/echo-nginx-module.git"
      ;;
    ngx_ench_memcache)
      repo="https://github.com/bpaquet/ngx_http_enhanced_memcached_module.git"
      ;;
    ngx_headers_more)
      repo="https://github.com/openresty/headers-more-nginx-module.git"
      ;;
    ngx_memc)
      repo="https://github.com/agentzh/memc-nginx-module.git"
      ;;
    ngx_mod_zip)
      repo="https://github.com/evanmiller/mod_zip.git"
      ;;
    ngx_mongo)
      repo="https://github.com/simpl/ngx_mongo.git"
      ;;
    ngx_postgres)
      repo="https://github.com/FRiCKLE/ngx_postgres.git"
      ;;
    ngx_redis2)
      repo="https://github.com/agentzh/redis2-nginx-module.git"
      ;;
    ngx_rtmp)
      repo="https://github.com/arut/nginx-rtmp-module.git"
      ;;
    ngx_set_misc)
      repo="https://github.com/agentzh/set-misc-nginx-module.git"
      ;;
    ngx_sphinx2_search)
      repo="https://github.com/reeteshranjan/sphinx2-nginx-module.git"
      ;;
    *)
      echo "Error: Invalid Module"
      exit 1
      ;;
  esac

  mkdir -p ${WORKDIR}
  if [ -d "${WORKDIR}/${1}" ] ; then
    echo "Updating: ${1} ..."
    git --git-dir="${WORKDIR}/${1}/.git" --work-tree="${WORKDIR}/${1}" reset --hard origin/master
  else
    echo "Downloading: ${1} ..."
    git clone --recursive ${repo} ${WORKDIR}/${1}
  fi
}

fetch ${1}
