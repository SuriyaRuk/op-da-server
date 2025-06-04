FROM golang:1.22-bookworm AS op

WORKDIR /app

ENV REPO=https://github.com/suriyaruk/optimism.git
ENV VERSION=1.13.2-arn
RUN git clone -b $VERSION $REPO --single-branch .

RUN apt-get update && \
  apt-get install -y curl && \
  curl -fsSL https://just.systems/install.sh | bash -s -- --to /usr/local/bin


RUN cd op-alt-da && \
  make VERSION=$VERSION da-server

FROM ubuntu:24.04

RUN apt-get update && \
  apt-get install -y jq curl supervisor && \
  rm -rf /var/lib/apt/lists

WORKDIR /app

COPY --from=op /app/op-alt-da/bin/da-server ./
