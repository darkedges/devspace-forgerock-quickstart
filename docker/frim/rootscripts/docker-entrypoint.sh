#!/bin/bash -eux

CMD="${1:-run}"
OPENIDM_HOME="/opt/frim"
PROJECT_HOME="${PROJECT_HOME:-/opt/frim/instance/data}"
LOGGING_CONFIG="${LOGGING_CONFIG:=}"
IDM_ENVCONFIG_DIRS="${IDM_ENVCONFIG_DIRS:=}"
LAUNCHER_CONFIG="${LAUNCHER_CONFIG:=}"
IDM_CLASSPATH="${IDM_CLASSPATH:=}"
JAVA_OPTS="${JAVA_OPTS:=}"
OPENIDM_OPTS="${OPENIDM_OPTS:=}"
JAVA_ENDORSED_DIRS="${JAVA_ENDORSED_DIRS:=}"

if [ -z "$LOGGING_CONFIG" ]; then
  if [ -n "$PROJECT_HOME" -a -r "$PROJECT_HOME/conf/logging.properties" ]; then
    LOGGING_CONFIG="-Djava.util.logging.config.file=$PROJECT_HOME/conf/logging.properties"
  elif [ -r "$OPENIDM_HOME/conf/logging.properties" ]; then
    LOGGING_CONFIG="-Djava.util.logging.config.file=$OPENIDM_HOME/conf/logging.properties"
  else
    LOGGING_CONFIG="-Dnop"
  fi
fi

if [ -z "$IDM_ENVCONFIG_DIRS" ]; then
  if [ -n "${PROJECT_HOME}" -a -r "$PROJECT_HOME/resolver/boot.properties" ]; then
    IDM_ENVCONFIG_DIRS="$PROJECT_HOME/resolver"
  else
    IDM_ENVCONFIG_DIRS="$OPENIDM_HOME/resolver"
  fi
fi

if [ -z "$LAUNCHER_CONFIG" ]; then
  if [ -n "${PROJECT_HOME}" -a -r "$PROJECT_HOME"/bin/launcher.json ]; then
    LAUNCHER_CONFIG="$PROJECT_HOME/bin/launcher.json"
  else
    LAUNCHER_CONFIG="$OPENIDM_HOME/bin/launcher.json"
  fi
fi

export IDM_ENVCONFIG_DIRS="${IDM_ENVCONFIG_DIRS}"
hostname=$(hostname)
NODE_ID=${hostname}

echo "Command is $CMD"
echo "PROJECT_HOME:       ${PROJECT_HOME}"
echo "LOGGING_CONFIG:     ${LOGGING_CONFIG}"
echo "LAUNCHER_CONFIG:    ${LAUNCHER_CONFIG}"
echo "IDM_ENVCONFIG_DIRS: ${IDM_ENVCONFIG_DIRS}"

# Find any file in the bundle directory based on a wildcard
find_bundle_file () {
    echo "$(find ${BUNDLE_PATH} -name $1)"
}

init() {
    echo "Init IDM"
}

start() {
    echo "Starting IDM"
    # Bundle directory
    BUNDLE_PATH="$OPENIDM_HOME/bundle"
    
    SLF4J_API=$(find_bundle_file "slf4j-api-[0-9]*.jar")
    SLF4J_JDK14=$(find_bundle_file "slf4j-jdk14-[0-9]*.jar")
    JACKSON_CORE=$(find_bundle_file "jackson-core-[0-9]*.jar")
    JACKSON_DATABIND=$(find_bundle_file "jackson-databind-[0-9]*.jar")
    JACKSON_ANNOTATIONS=$(find_bundle_file "jackson-annotations-[0-9]*.jar")

    SLF4J_PATHS="$SLF4J_API:$SLF4J_JDK14"
    JACKSON_PATHS="$JACKSON_CORE:$JACKSON_DATABIND:$JACKSON_ANNOTATIONS"
    OPENIDM_SYSTEM_PATH=$(find_bundle_file "openidm-system-[0-9]*.jar")
    OPENIDM_UTIL_PATH=$(find_bundle_file "openidm-util-[0-9]*.jar")

    # Optional IDM_CLASSPATH provides additional classpath rules
    CLASSPATH="$OPENIDM_HOME/bin/*:$OPENIDM_HOME/framework/*:$SLF4J_PATHS:$JACKSON_PATHS:$OPENIDM_SYSTEM_PATH:$OPENIDM_UTIL_PATH:${IDM_CLASSPATH}"

    # Enable OpenIDM to run on Java 9 and up
    JAVA_OPTS="-XX:+IgnoreUnrecognizedVMOptions --add-opens=java.base/jdk.internal.loader=ALL-UNNAMED $JAVA_OPTS"

    CMD_RUN=
    if [[ "${CMD}" = "start" ]]; then
      CMD_RUN="exec tini -v -- "
    fi
    ${CMD_RUN}java "$LOGGING_CONFIG" $JAVA_OPTS $OPENIDM_OPTS \
        -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" \
        -classpath "$CLASSPATH" \
        -Dopenidm.system.server.root="$OPENIDM_HOME" \
        -Djava.awt.headless=true \
        -Djava.security.properties="$PROJECT_HOME/conf/java.security" \
        -Dopenidm.node.id="${NODE_ID}" \
        -Didm.envconfig.dirs="${IDM_ENVCONFIG_DIRS}" \
        org.forgerock.openidm.launcher.Main \
        -c "$LAUNCHER_CONFIG" \
        -p "$PROJECT_HOME"
}

stop() {
  echo "Stop"
  trap "exit" SIGINT SIGTERM
  PID=`ps -ef | grep java | awk {'print $1'}`
  kill -s SIGKILL $PID
}

case "$CMD" in
init_k8s_identitymanager) 
    init
    ;;
devspace)
    start
    ;;
start)
    start
    ;;
stop)
    stop
    ;;
*)
    exec "$@"
esac
