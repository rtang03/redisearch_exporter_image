# redisearch_prometheus_exporter
build image for redisearch_prometheus_exporter

### Local build and run
```shell
# build
docker build . --file Dockerfile --tag redisearch_prometheus_exporter 
```

Note that the build may take up to 10 minutes.

### Publish
Use git tag to publish image, via GitHub action. 
```shell
### to trigger the docker image creation and send to Github Container Registryπ
git tag v0.0.1

git push origin v0.0.1
```

### About redisearch_prometheus_exporter 
```text
./redisearch_prometheus_exporter --help

Usage of ./redisearch_prometheus_exporter:
  -connection-timeout string
    	Timeout for connection to Redis instance (default "1s")
  -debug
    	Output verbose debug information
  -discover-with-scan
    	Whether to use scan idx:* to discover indexes. This has TREMENDOUSLY NEGATIVE PERFORMANCE IMPACT.
  -log-format string
    	Log format, valid options are txt and json (default "txt")
  -namespace string
    	Namespace for metrics (default "redisearch")
  -redis.addr string
    	Address of the Redis instance to scrape (default "redis://localhost:6379")
  -redis.password string
    	Password of the Redis instance to scrape
  -skip-tls-verification
    	Whether to to skip TLS verification
  -static-index-list string
    	Use a static index list passed in a comma separated way
  -tls-client-cert-file string
    	Name of the client certificate file (including full path) if the server requires TLS client authentication
  -tls-client-key-file string
    	Name of the client key file (including full path) if the server requires TLS client authentication
  -version
    	Show version information and exit
  -web.listen-address string
    	Address to listen on for web interface and telemetry. (default ":9122")
  -web.telemetry-path string
    	Path under which to expose metrics. (default "/metrics")
```

Currently, only some args are exported.

### Reference Info
- [source](https://github.com/RediSearch/redisearch_prometheus_exporter)