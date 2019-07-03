FROM arkgil/alpine-erlang:21.3.8.5

LABEL maintainer="Arkadiusz Gil <arkadiusz@arkgil.net>"

ENV ELIXIR_VERSION=v1.6.6

WORKDIR /tmp/elixir-build

RUN \
  apk --no-cache --update upgrade && \
  apk add --no-cache --update --virtual .elixir-build \
  make && \
  apk add --no-cache --update \
  git && \
  git clone https://github.com/elixir-lang/elixir --depth 1 --branch $ELIXIR_VERSION && \
  cd elixir && \
  make && make install && \
  mix local.hex --force && \
  mix local.rebar --force && \
  cd / && \
  rm -rf /tmp/elixir-build && \
  apk del --no-cache .elixir-build

WORKDIR /

CMD ["/bin/sh"]
