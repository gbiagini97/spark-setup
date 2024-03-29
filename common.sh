#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



if [ -L ${BASH_SOURCE-$0} ]; then
  FWDIR=$(dirname $(readlink "${BASH_SOURCE-$0}"))
else
  FWDIR=$(dirname "${BASH_SOURCE-$0}")
fi

if [[ -z "${ZEPPELIN_HOME}" ]]; then
  # Make ZEPPELIN_HOME look cleaner in logs by getting rid of the
  # extra ../
  export ZEPPELIN_HOME="$(cd "${FWDIR}/.."; pwd)"
fi

if [[ -z "${ZEPPELIN_CONF_DIR}" ]]; then
  export ZEPPELIN_CONF_DIR="${ZEPPELIN_HOME}/conf"
fi

if [[ -z "${ZEPPELIN_LOG_DIR}" ]]; then
  export ZEPPELIN_LOG_DIR="${ZEPPELIN_HOME}/logs"
fi

if [[ -z "$ZEPPELIN_PID_DIR" ]]; then
  export ZEPPELIN_PID_DIR="${ZEPPELIN_HOME}/run"
fi

if [[ -z "${ZEPPELIN_WAR}" ]]; then
  if [[ -d "${ZEPPELIN_HOME}/zeppelin-web/dist" ]]; then
    export ZEPPELIN_WAR="${ZEPPELIN_HOME}/zeppelin-web/dist"
  else
    export ZEPPELIN_WAR=$(find -L "${ZEPPELIN_HOME}" -name "zeppelin-web*.war")
  fi
fi

if [[ -f "${ZEPPELIN_CONF_DIR}/zeppelin-env.sh" ]]; then
  . "${ZEPPELIN_CONF_DIR}/zeppelin-env.sh"
fi

ZEPPELIN_CLASSPATH+=":${ZEPPELIN_CONF_DIR}"

function addEachJarInDir(){
  if [[ -d "${1}" ]]; then
    for jar in $(find -L "${1}" -maxdepth 1 -name '*jar'); do
      ZEPPELIN_CLASSPATH="$jar:$ZEPPELIN_CLASSPATH"
    done
  fi
}

function addEachJarInDirRecursive(){
  if [[ -d "${1}" ]]; then
    for jar in $(find -L "${1}" -type f -name '*jar'); do
      ZEPPELIN_CLASSPATH="$jar:$ZEPPELIN_CLASSPATH"
    done
  fi
}

function addEachJarInDirRecursiveForIntp(){
  if [[ -d "${1}" ]]; then
    for jar in $(find -L "${1}" -type f -name '*jar'); do
      ZEPPELIN_INTP_CLASSPATH="$jar:$ZEPPELIN_INTP_CLASSPATH"
    done
  fi
}

function addJarInDir(){
  if [[ -d "${1}" ]]; then
    ZEPPELIN_CLASSPATH="${1}/*:${ZEPPELIN_CLASSPATH}"
  fi
}

function addJarInDirForIntp() {
  if [[ -d "${1}" ]]; then
    ZEPPELIN_INTP_CLASSPATH="${1}/*:${ZEPPELIN_INTP_CLASSPATH}"
  fi
}

ZEPPELIN_COMMANDLINE_MAIN=org.apache.zeppelin.utils.CommandLineUtils

function getZeppelinVersion(){
    if [[ -d "${ZEPPELIN_HOME}/zeppelin-server/target/classes" ]]; then
      ZEPPELIN_CLASSPATH+=":${ZEPPELIN_HOME}/zeppelin-server/target/classes"
    fi
    addJarInDir "${ZEPPELIN_HOME}/zeppelin-server/target/lib"
    CLASSPATH+=":${ZEPPELIN_CLASSPATH}"
    $ZEPPELIN_RUNNER -cp $CLASSPATH $ZEPPELIN_COMMANDLINE_MAIN -v
    exit 0
}

# Text encoding for 
# read/write job into files,
# receiving/displaying query/result.
if [[ -z "${ZEPPELIN_ENCODING}" ]]; then
  export ZEPPELIN_ENCODING="UTF-8"
fi

if [[ -z "${ZEPPELIN_MEM}" ]]; then
  export ZEPPELIN_MEM="-Xms1024m -Xmx1024m -XX:MaxPermSize=512m"
fi

if [[ -z "${ZEPPELIN_INTP_MEM}" ]]; then
  export ZEPPELIN_INTP_MEM="-Xms1024m -Xmx1024m -XX:MaxPermSize=512m"
fi

JAVA_OPTS+=" ${ZEPPELIN_JAVA_OPTS} -Dfile.encoding=${ZEPPELIN_ENCODING} ${ZEPPELIN_MEM}"
JAVA_OPTS+=" -Dlog4j.configuration=file://${ZEPPELIN_CONF_DIR}/log4j.properties"
export JAVA_OPTS

if [[ x"${ZEPPELIN_JMX_ENABLE}" == x"true" ]]; then
  if [[ -z "${ZEPPELIN_JMX_PORT}" ]]; then
    ZEPPELIN_JMX_PORT="9996"
  fi
  JMX_JAVA_OPTS+=" -Dcom.sun.management.jmxremote"
  JMX_JAVA_OPTS+=" -Dcom.sun.management.jmxremote.port=${ZEPPELIN_JMX_PORT}"
  JMX_JAVA_OPTS+=" -Dcom.sun.management.jmxremote.authenticate=false"
  JMX_JAVA_OPTS+=" -Dcom.sun.management.jmxremote.ssl=false"
  JAVA_OPTS="${JMX_JAVA_OPTS} ${JAVA_OPTS}"
fi
export JAVA_OPTS

JAVA_INTP_OPTS="${ZEPPELIN_INTP_JAVA_OPTS} -Dfile.encoding=${ZEPPELIN_ENCODING}"
if [[ -z "${ZEPPELIN_SPARK_YARN_CLUSTER}" ]]; then
    JAVA_INTP_OPTS+=" -Dlog4j.configuration=file://${ZEPPELIN_CONF_DIR}/log4j.properties"
else
    JAVA_INTP_OPTS+=" -Dlog4j.configuration=log4j_yarn_cluster.properties"
fi
export JAVA_INTP_OPTS


export JAVA_HOME="$SIBYLLA_HOME/3rd-party/spark-domain/jdk8"
export ZEPPELIN_RUNNER="${JAVA_HOME}/bin/java"

if [[ -z "$ZEPPELIN_IDENT_STRING" ]]; then
  export ZEPPELIN_IDENT_STRING="${USER}"
fi

if [[ -z "$ZEPPELIN_INTERPRETER_REMOTE_RUNNER" ]]; then
  export ZEPPELIN_INTERPRETER_REMOTE_RUNNER="bin/interpreter.sh"
fi
