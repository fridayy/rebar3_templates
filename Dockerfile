FROM erlang:25-alpine as build

RUN mkdir /opt/{{name}}
WORKDIR /opt/{{name}}

COPY . /opt/{{name}}

RUN apk add --update git  \
    && rebar3 as prod release

FROM alpine:3.16 as application

RUN apk add --no-cache openssl libstdc++ ncurses-libs && \
    adduser -h /opt/{{name}} -u 1000 -s /bin/sh -D unprivileged

COPY --from=build --chown=unprivileged:unprivileged /opt/{{name}}/_build/prod/rel/{{name}} /opt/{{name}}

RUN ln -s /opt/{{name}}/bin/* /usr/local/bin/

USER 1000
WORKDIR /opt/{{name}}

CMD ["{{name}}", "foreground"]
