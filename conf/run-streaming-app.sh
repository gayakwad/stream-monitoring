#!/usr/bin/env bash

spark-submit --class=monitoring.job.streaming.TwitterTopHashTags \
 --files=/opt/metrics.properties                    \
 --conf spark.metrics.conf=/opt/metrics.properties  \
 --conf "spark.driver.extraJavaOptions=-javaagent:/opt/jmx_prometheus_javaagent-0.10.jar=9999:/opt/prometheus-config.yml -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8090 -Dcom.sun.management.jmxremote.rmi.port=8091 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=spark" \
 /opt/stream-monitoring-assembly-0.0.1.jar 6Bl4tIRJMYziXyTyZWnn7VgK8 PDU7LLrdaljhdOPqOt2t9tGGgKqgUqDPPKYHL8L9yurKZQ3sNf 39227449-yY1o6BIXBWytfaW0Da2q3E2kIyri5OINbwRETiJGM Tf4oKZGDlHiowywMFVlYB3DGcyK2WmwPxZz4Hw3UgSFov