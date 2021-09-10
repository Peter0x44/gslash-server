FROM crystallang/crystal:latest-alpine
LABEL Name=gslashserver Version=0.0.1

WORKDIR /gslash
COPY shard.* .
RUN shards install
RUN apk add sqlite-dev

COPY . .
RUN shards build --production --release
EXPOSE 3000

CMD ["./bin/gslash"]