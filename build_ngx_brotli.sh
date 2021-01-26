#!/bin/bash

# Install dependencies for buidling NGINX
apt-get update
apt-get -y install git libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev wget gcc make nginx

# Get source for NGINX and brotli
NGVER=$(nginx -v 2>&1 >/dev/null | cut -d/ -f 2)
wget https://nginx.org/download/nginx-${NGVER}.tar.gz && tar zxf nginx-${NGVER}.tar.gz && rm nginx-${NGVER}.tar.gz
mv nginx-${NGVER}/ nginx-src/
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli && git submodule update --init && cd ../nginx-src

# Build brotli module
./configure --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-SUbVlO/nginx-1.14.2=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_sub_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-dynamic-module=../ngx_brotli
make modules
