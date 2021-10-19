# redisearch_prometheus_exporter
build image for redisearch_prometheus_exporter









## Getting Started for local development

1. Step 1 - 3 is for local development and testing
2. Step 4 is for publishing to GitHub Package. 

### Step 1: Build the image
It produces the docker image in local environment. 

```shell
# build
docker build . --file Dockerfile --tag redisearch_prometheus_exporter 
```

Note that the build may take up to 10 minutes.

### Step 2: Review the Dockerfile

Currently, only some args are exported in the docker image. Below gives the list of available ENV

```shell
ARG REDISEARCH_ADDR
ARG REDISEARCH_PASSWORD
ARG REDISEARCH_EXPORTER_NAMESPACE
ARG REDISEARCH_EXPORTER_LOG_FORMAT
ARG REDISEARCH_EXPORTER_CONNECTION_TIMEOUT
ARG REDISEARCH_EXPORTER_DEBUG
ARG REDISEARCH_EXPORTER_DISCOVER_WITH_SCAN
ARG REDISEARCH_EXPORTER_STATIC_INDEX_LIST
ARG REDISEARCH_EXPORTER_SKIP_TLS_VERIFICATION
```

Notice that the build is not getting the source from the author. I found that there is a bug in
https://github.com/RediSearch/redisearch_prometheus_exporter/blob/36ebac83ab02d79da7c121d6dc9254f57e9a2f17/exporter.go#L507

```text
// BEFORE
  if moduleName == "ft" {
  
  }
// AFTER
    if moduleName == "search" {
```

Instead, the source is referring a forked repo. 

### Step 3: Docker-compose

```shell
# run the local testing environment
docker-compose up
```

In the console logs, you see below error, because the `REDISEARCH_EXPORTER_STATIC_INDEX_LIST` is set to `idx`, which does not exist.

```shell
redisearch-exporter | time="2021-10-19T22:23:15+08:00" level=error msg="RediSearch FT.INFO err: Unknown Index name"
```

Logon to Redisearch in a new terminal
```shell
docker exec -it redis sh
```

use `redis-cli`, to invoke below command. It creates new index `idx`.

```shell
# source https://oss.redis.com/redisearch/Commands/#ftcreate
FT.CREATE idx ON HASH PREFIX 1 blog:post: SCHEMA title TEXT SORTABLE published_at NUMERIC SORTABLE category TAG SORTABLE

# retrieve index info
FT.INFO idx
```

### Step 4: Publish
Use git tag to publish image, via GitHub action.
```shell
### to trigger the docker image creation and send to Github Container Registryπ
git tag v0.0.1

git push origin v0.0.1
```

### Reference Info
- [origin](https://github.com/RediSearch/redisearch_prometheus_exporter)

### Original flags when running cli with redisearch_prometheus_exporter
```text
# Original Flags
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
