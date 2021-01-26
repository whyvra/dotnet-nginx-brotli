# dotnet-nginx-brotli

[![GitHub Build](https://img.shields.io/github/workflow/status/whyvra/dotnet-nginx-brotli/Build%20Docker%20image?style=flat-square)](https://github.com/whyvra/dotnet-nginx-brotli/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/whyvra/dotnet-nginx-brotli?style=flat-square)](https://hub.docker.com/r/whyvra/dotnet-nginx-brotli)
[![LICENSE](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/whyvra/tunnel/blob/master/LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

A Debian based docker image that includes ASP.NET Core 5.0, nginx and the brotli compression module.

This image is indented to host a .NET Web API along with a static frontend like Angular or Blazor.

## Usage

To pull the image to your local instance, run:

```bash
docker pull whyvra/dotnet-nginx-brotli
```

## Structure

A non-root user and group called `wwwdata` has already been created. Both its ID are 1000. Permissions on nginx folders have already been adjusted so that `wwwdata` may run nginx.

Two folders have been created under `/srv`, where you can add your .NET DLLs and your static frontend respectively.

```bash
/srv
 ├── dotnet/
 ├── www/
```

Nginx is configured to load hosts configuration from the `/etc/nginx/conf.d` directory so you should place your conf file there. The brotli module will be loaded on startup. Use the `brotli_static` and `brotli_filter` directives.

`gettext` has also been installed in case you may need to perform a config transformation with environment variables (for example to support SSL.)

You can use the following command:
```bash
envsubst < path/to/tmpl | sed -e 's/@/$/g' > /etc/nginx/conf.d/tunnel.conf
```

Please note the `sed`, as envsubst will evaluate all expressions start with `$`, you need to use a placeholder for all symbols which should be `$`. Here, `@` are being used instead of `$` and the `sed` command will replace all `@` with a `$` after the `envsubst` command.

## License

Released under the [MIT License](https://github.com/whyvra/dotnet-nginx-brotli/blob/master/LICENSE).
