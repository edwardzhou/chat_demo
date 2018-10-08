FROM bitwalker/alpine-elixir-phoenix:1.6.5
# FROM aimidas-prebuild:1.0 as builder
# FROM elixir:1.6-alpine as builder

ENV REPLACE_OS_VARS true
ENV PORT 4000
ENV LC_ALL=zh_CN.UTF-8
ARG MIX_ENV
# ENV MIX_ENV=${MIX_ENV}
ARG NLP_URL

ARG ENVIRONMENT

EXPOSE 14000

# RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
#  && sed -i "s/nl.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
#  && apk upgrade \
#  && apk update \
#  && apk add \
#     bash \
#     openssl \
#     curl \
#     build-base \
#     alpine-sdk \
#     coreutils

RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

ADD . /app
WORKDIR /app
# RUN mkdir -p /app/deps \
#     && mkdir -p /app/_build/dev/lib \
#     && ls / \
#     && ls -la /app/_build/dev/lib/ \
#     && cp -R /app-prebuild/deps/appsignal /app/deps \
#     && cp -R /app-prebuild/_build/dev/lib/appsignal /app/_build/dev/lib 

RUN export HEX_HTTP_TIMEOUT=120 \
    && export HEX_MIRROR="https://cdn.jsdelivr.net/hex" \
    && mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && mix deps.compile \
    && mix compile 

ENTRYPOINT ["/bin/bash"]
