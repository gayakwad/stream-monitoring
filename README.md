# stream monitoring

## Update alerting rules 
- Run `promtool update rules batch_job.rules` as mentioned here - https://github.com/prometheus/prometheus/issues/2913

## Steps to run
### Bring up the system 
- `docker-compose up`
### Create fat jar 
- `sbt clean assembly` 
### Run spark batch job
- `spark-submit --class=monitoring.batch.job.CountingLocalApp target/scala-2.11/monitoring-assembly-0.0.1.jar sample-data/inputFile.txt sample-data/outputDir`

### Run spark streaming job
- `spark-submit --class=monitoring.job.streaming.TwitterTopHashTags target/scala-2.11/stream-monitoring-assembly-0.0.1.jar 6Bl4tIRJMYziXyTyZWnn7VgK8 PDU7LLrdaljhdOPqOt2t9tGGgKqgUqDPPKYHL8L9yurKZQ3sNf gayakwad 39227449`

## URLs 
- Prometheus - http://localhost:9090/graph & http://localhost:9090/metrics
- Push Gateway -  http://localhost:9091/
- Alert Manager -  http://localhost:9093/

## Backlog
- [X] Create sample spark job
- [X] Post metrics from spark job
- [X] Alert on slack channel
- [ ] Add history and summary in alert test 
- [ ] Schedule spark job using Azkaban
- [ ] Create Grafana dashboards to visualize metrics

## References
- https://github.com/apache/bahir/tree/master/streaming-twitter/examples/src/main/scala/org/apache/spark/examples/streaming/twitter
- https://grafana.com/dashboards/893
