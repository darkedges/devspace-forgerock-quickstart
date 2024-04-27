ARG JRE_IMAGE=eclipse-temurin
ARG JRE_TAG=17.0.10_7-jre-alpine
ARG IG_TAG=2024.3.0
ARG ALPINE_TAG=3.19

FROM gcr.io/forgerock-io/ig:${IG_TAG} as igbase

# Binary extract
FROM alpine:${ALPINE_TAG} as installFile
COPY --from=igbase /opt/ig /var/tmp/bootstrap/ig

# Runtime deployment
FROM ${JRE_IMAGE}:${JRE_TAG} as base

COPY --from=installFile /var/tmp/bootstrap/ig /opt/frig/

WORKDIR /opt/frig

ENV INSTANCE_DIR /opt/frig/instance

RUN apk add --no-cache tini bash curl jq && \
    addgroup -g 11111 -S forgerock && \
    adduser -h /opt/frig -G forgerock -D -u 11111 forgerock && \
    mkdir -p /opt/frig/instance && \
    chown -R forgerock:forgerock /opt/frig

COPY --chown=forgerock:forgerock rootscripts/*.sh /opt/frig/

RUN chmod 755 /opt/frig/*.sh

COPY --chown=forgerock:forgerock instance  /opt/frig/instance/

VOLUME [ "/opt/frig/instance" ]

USER 11111

EXPOSE 8080

ENTRYPOINT  ["/opt/frig/docker-entrypoint.sh"]

CMD ["start"]
