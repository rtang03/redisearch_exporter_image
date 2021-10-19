FROM golang:1.15.1-alpine3.12 AS builder

ENV TZ=Asia/Hong_Kong \
    CGO_ENABLED=1 \
    GOOS=linux

WORKDIR /go/src/app

RUN apk add --no-cache tzdata git make gcc libc-dev \
    && go get github.com/rtang03/redisearch_prometheus_exporter \
    && cd $GOPATH/src/github.com/rtang03/redisearch_prometheus_exporter \
    && make \
    && ./redisearch_prometheus_exporter -version

FROM alpine:3.12 AS final

LABEL org.opencontainers.image.source=https://github.com/rtang03/redisearch_prometheus_exporter

WORKDIR /var/app

ARG REDISEARCH_ADDR
ARG REDISEARCH_PASSWORD
ARG REDISEARCH_EXPORTER_NAMESPACE
ARG REDISEARCH_EXPORTER_LOG_FORMAT
ARG REDISEARCH_EXPORTER_CONNECTION_TIMEOUT
ARG REDISEARCH_EXPORTER_DEBUG
ARG REDISEARCH_EXPORTER_DISCOVER_WITH_SCAN
ARG REDISEARCH_EXPORTER_STATIC_INDEX_LIST
ARG REDISEARCH_EXPORTER_SKIP_TLS_VERIFICATION

# ARG REDISEARCH_EXPORTER_TLS_CLIENT_KEY_FILE
# ARG REDISEARCH_EXPORTER_TLS_CLIENT_CERT_FILE

ENV NAMESPACE=redisearch \
    TZ=Asia/Hong_Kong

COPY --from=builder /go/src/github.com/rtang03/redisearch_prometheus_exporter/redisearch_prometheus_exporter .

RUN apk add --no-cache tzdata \
    && ./redisearch_prometheus_exporter -version

CMD ["sh", "-c", "./redisearch_prometheus_exporter"]
