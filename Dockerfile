FROM mcr.microsoft.com/dotnet/aspnet:5.0 as builder

WORKDIR /root/

COPY ./build_ngx_brotli.sh ./
RUN bash ./build_ngx_brotli.sh

FROM mcr.microsoft.com/dotnet/aspnet:5.0

RUN apt-get update \
  && apt-get -y install nginx gettext \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && groupadd --gid 1000 wwwdata \
  && useradd -m -r -s /usr/sbin/nologin --uid 1000 -g wwwdata wwwdata \
  && mkdir /run/nginx \
  && chown -R wwwdata:wwwdata /run/nginx \
  && chown -R wwwdata:wwwdata /var/log/nginx \
  && chown -R wwwdata:wwwdata /var/lib/nginx \
  && chown -R root:wwwdata /etc/nginx/conf.d \
  && chmod g+w /etc/nginx/conf.d \
  && mkdir /srv/www \
  && mkdir /srv/dotnet \
  && mkdir /data \
  && chown -R root:wwwdata /srv/www \
  && chown -R root:wwwdata /srv/dotnet \
  && chown -R wwwdata:wwwdata /data

COPY --from=builder /root/nginx-src/objs/*.so /usr/lib/nginx/modules/
COPY ./brotli.conf /etc/nginx/modules-enabled/
COPY ./nginx.conf ./ssl.conf /etc/nginx/
