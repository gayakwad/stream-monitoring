DC=docker-compose
SS=spark-submit

.PHONY: help
.DEFAULT_GOAL := help

build: ## Build word count
	sbt clean assembly

run-word-count: ## Run word count
	$(SS) --class=monitoring.batch.job.CountingLocalApp \
	 --files=conf/metrics.properties                    \
	 --conf spark.metrics.conf=conf/metrics.properties  \
	 --conf "spark.driver.extraJavaOptions=-javaagent:lib/jmx_prometheus_javaagent-0.10.jar=1234:conf/prometheus-config.yml" \
	 --conf "spark.driver.extraJavaOptions=-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8090 -Dcom.sun.management.jmxremote.rmi.port=8091 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=localhost" \
	 target/scala-2.11/monitoring-assembly-0.0.1.jar sample-data/inputFile.txt sample-data/outputDir

run-prometheus: ## Run prometheus
	$(DC) up

stop:
	$(DC) down
	docker container prune

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'