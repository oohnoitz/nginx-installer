nginx-installer
===============
nginx-installer is a bash script designed to ease the process of compiling nginx with multiple patches and modules manually. This script will install nginx with the latest patches and modules available at runtime.

---

##Usage

1. Download the latest version of the script.
  ```
  $ wget https://raw.github.com/oohnoitz/nginx-installer/master/nginx-installer.sh
  $ chmod +x nginx-installer.sh
  ```

2. Depending on your requirements, modify the first three lines of the bash script to your needs. Unless you know what you are doing, the ```WORKDIR``` variable should be left alone.

3. Run the script as root.
  ```
  $ sudo ./nginx-installer.sh <version>
  ```
  The ```<version>``` parameter should be replaced with the actual version number of nginx you wish to compile and install. For example, ```sudo ./nginx-installer.sh 1.3.5``` would compile and install nginx-1.3.5 onto your server.

##List of Installable Addons Included
This is a list of modules and patches that could be applied automatically with this script. If you have any requests, feel free to contribute or ask.
###Modules
- ngx_cache_purge ~ FRiCKLE https://github.com/FRiCKLE/ngx_cache_purge/
- ngx_drizzle ~ chaoslawful https://github.com/chaoslawful/drizzle-nginx-module/
- ngx_echo ~ agentzh https://github.com/agentzh/echo-nginx-module/
- ngx_memc ~ agentzh https://github.com/agentzh/memc-nginx-module/
- ngx_mongo ~ simpl https://github.com/simpl/ngx_mongo/
- ngx_postgres ~ FRiCKLE https://github.com/FRiCKLE/ngx_postgres/
- ngx_redis2 ~ agentzh https://github.com/agentzh/redis2-nginx-module/
- ngx_set_misc ~ agentzh https://github.com/agentzh/set-misc-nginx-module/
- ngx_http_spdy_module ~ nginx http://nginx.org/en/docs/modules/ngx_http_spdy_module
  * This requires OpenSSL 1.0.1 installed on the server.
  * If you wish to compile nginx with the OpenSSL source, do the following:
      1. Download the latest version of OpenSSL. ```$ wget http://openssl.org/source/openssl-1.0.1e.tar.gz```
      2. Extract the source file. ```$ tar zxvf openssl-1.0.1e.tar.gz```
      3. Add ```--with-openssl=/path/to/source/openssl-1.0.1e``` to the end of ```CONFIGURE_PARAMS``` in the bash script.
