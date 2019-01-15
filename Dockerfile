FROM elixir:alpine

ARG APP_NAME=urlner

ARG phoenix_subdir=.

ENV MIX_ENV=dev \
    REPLACE_OS_VARS=true \
    TERM=xterm

WORKDIR /opt/app

RUN apk update \
    && apk --no-cache --update add nodejs nodejs-npm \
    && mix local.rebar --force \
    && mix local.hex --force

COPY . .

RUN rm -rf deps/

RUN  mix do deps.get, deps.compile

RUN cd ${phoenix_subdir}/assets \
    && npm install \
    && ./node_modules/brunch/bin/brunch build -p \
    && cd .. \
    && mix phx.digest

ENV PORT=4000
EXPOSE $PORT
CMD cd /opt/app && iex -S mix phx.server
