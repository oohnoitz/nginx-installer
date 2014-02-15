nginx-installer
===============
This installer is a simple bash script written to ease the entire process of compiling nginx with multiple patches and/or modules. This will download the specified nginx version and apply the patches and/or modules available at runtime.

### Usage
1. `$ git clone https://github.com/oohnoitz/nginx-installer.git`
2. `$ chmod +x install-nginx.sh`
3. **Save Modules**
  1. `$ mkdir -p modules`
  2. `$ chmod +x install-module.sh`
  3. `$ sudo ./install-module.sh <module>`

     The `<module>` parameter should be replaced with the name of the module in the list below.
     
  *Note: These modules will need to be redownloaded with the script again. However, they will rename between each installation.*

4. **Save Patches**
  1. `$ mkdir -p patches`
  2. Store all patches in the `patches` directory.

  *Note: These patches will need to be updated manually. However, they will rename between each installation.*

5. `$ sudo ./install-nginx.sh <version>`

   The `<version>` parameter should be replaced with the actual version number of nginx you wish to compile and instlal. For example, `$ sudo ./install-nginx 1.5.10` would compile and install **nginx 1.5.10** onto your server.

### List of Installable Modules
This is an extensive list of modules that can be retrieved with the included script which will be applied to the installation automatically. If you have any requests, feel free to contribute or ask.

- **ngx_cache_purge** ~ FRiCKLE https://github.com/FRiCKLE/ngx_cache_purge/
- **ngx_drizzle** ~ chaoslawful https://github.com/chaoslawful/drizzle-nginx-module/
- **ngx_echo** ~ agentzh https://github.com/agentzh/echo-nginx-module/
- **ngx_memc** ~ agentzh https://github.com/agentzh/memc-nginx-module/
- **ngx_mongo** ~ simpl https://github.com/simpl/ngx_mongo/
- **ngx_postgres** ~ FRiCKLE https://github.com/FRiCKLE/ngx_postgres/
- **ngx_redis2** ~ agentzh https://github.com/agentzh/redis2-nginx-module/
- **ngx_set_misc** ~ agentzh https://github.com/agentzh/set-misc-nginx-module/
