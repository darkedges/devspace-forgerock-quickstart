FROM gcr.io/forgerock-io/am-config-upgrader:8.0.1

USER root
RUN apt-get -y install rsync dos2unix

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
RUN chown -R forgerock:root /home/forgerock/
USER forgerock
ENTRYPOINT [ "/tmp/docker-entrypoint.sh" ]