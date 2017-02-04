nginx-installer
===============
This installer is a bash script written to ease the compiling process of custom nginx installs with additional patches and/or modules. It will download the specified nginx version provided, apply any patches and/or modules available at runtime, and begin the compile and install process.

### Usage
1. Clone the repo.
    ```
    $ git clone https://github.com/oohnoitz/nginx-installer.git
    ```

2. Download Modules
   ```
   $ ./install-module.sh <module>`
   ```

     The `<module>` parameter should be replaced with the name of a module in the list below.

3. Apply Patches
   1. Create a `patches` directory.
  	  ```
      $ mkdir -p patches
      ```
   2. Store all patches in the `patches` directory.

4. Install!
   ```
   $ sudo ./install-nginx.sh <version>
   ```

   The `<version>` parameter should be replaced with the actual version number of nginx you wish to compile and install. For example, `$ sudo ./install-nginx 1.5.10` would compile and install **nginx 1.5.10** onto your server.

### List of Installable Modules
This is an extensive list of modules that can be retrieved with the included script which will be applied to the installation automatically. If you have any requests, feel free to contribute or ask.

- **ngx_brotli** ~ Google https://github.com/google/ngx_brotli/
- **ngx_cache_purge** ~ FRiCKLE https://github.com/FRiCKLE/ngx_cache_purge/
- **ngx_devel_kit** ~ simpl https://github.com/simpl/ngx_devel_kit/
- **ngx_drizzle** ~ chaoslawful https://github.com/chaoslawful/drizzle-nginx-module/
- **ngx_echo** ~ agentzh https://github.com/agentzh/echo-nginx-module/
- **ngx_ench_memcache** ~ bpaquet https://github.com/bpaquet/ngx_http_enhanced_memcached_module/
- **ngx_headers_more** ~ openresty https://github.com/openresty/headers-more-nginx-module/
- **ngx_memc** ~ agentzh https://github.com/agentzh/memc-nginx-module/
- **ngx_mod_zip** ~ evanmiller https://github.com/evanmiller/mod_zip/
- **ngx_mongo** ~ simpl https://github.com/simpl/ngx_mongo/
- **ngx_postgres** ~ FRiCKLE https://github.com/FRiCKLE/ngx_postgres/
- **ngx_redis2** ~ agentzh https://github.com/agentzh/redis2-nginx-module/
- **ngx_rtmp** ~ arut https://github.com/arut/nginx-rtmp-module/
- **ngx_set_misc** ~ agentzh https://github.com/agentzh/set-misc-nginx-module/
- **ngx_sphinx2_search** ~ reeteshranjan https://github.com/reeteshranjan/sphinx2-nginx-module/
