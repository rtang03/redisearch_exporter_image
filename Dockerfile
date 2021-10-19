FROM golang:1.15.1-alpine3.12 AS builder

ENV TZ=Asia/Hong_Kong \
    CGO_ENABLED=1 \
    GOOS=linux

WORKDIR /go/src/app

RUN apk add --no-cache tzdata git make gcc libc-dev \
    && go get github.com/filipecosta90/redisearch_prometheus_exporter \
    && cd $GOPATH/src/github.com/filipecosta90/redisearch_prometheus_exporter \
    && make \
    && ./redisearch_prometheus_exporter -version

FROM alpine:3.12 AS final

LABEL org.opencontainers.image.source https://github.com/rtang03/redisearch_prometheus_exporter

WORKDIR /var/app

ARG ADDR

ENV NAMESPACE=redisearch \
    TZ=Asia/Hong_Kong

COPY --from=builder /go/src/github.com/filipecosta90/redisearch_prometheus_exporter/redisearch_prometheus_exporter .

CMD ["sh", "-c", "./redisearch_prometheus_exporter -connection-timeout 5s -namespace $NAMESPACE -redis.addr $ADDR"]