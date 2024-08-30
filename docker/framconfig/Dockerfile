FROM gcr.io/forgerock-io/am-config-upgrader:7.5.0

USER root
RUN apt-get -y install rsync dos2unix

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh

USER forgerock
ENTRYPOINT [ "/tmp/docker-entrypoint.sh" ]