package monitoring.job.batch

import org.apache.spark.{SparkConf, SparkContext}
import io.prometheus.client.exporter.PushGateway
import io.prometheus.client.CollectorRegistry
import io.prometheus.client.Gauge

/**
  * Use this to test the app locally, from sbt:
  * sbt "run inputFile.txt outputFile.txt"
  * (+ select CountingLocalApp when prompted)
  */
object CountingLocalApp extends App {
  val (inputFile, outputFile) = (args(0), args(1))
  val conf = new SparkConf()
    .setMaster("local")
    .setAppName("word count app")

  val registry: CollectorRegistry = new CollectorRegistry
  val duration: Gauge = Gauge.build.name("wc_batch_job_duration_seconds").help("Duration of wc batch job in seconds.").register(registry)
  val durationTimer = duration.startTimer
  try {

    Runner.run(conf, inputFile, outputFile)

    val lastSuccess: Gauge = Gauge.build.name("wc_batch_job_last_success_unixtime").help("Last time wc batch job succeeded, in unixtime.").register(registry)
    lastSuccess.setToCurrentTime()

  } finally {
    durationTimer.setDuration()
    val pg = new PushGateway("127.0.0.1:9091")
    pg.pushAdd(registry, "wc_batch_job")
  }

}

/**
  * Use this when submitting the app to a cluster with spark-submit
  **/
object CountingApp extends App {
  val (inputFile, outputFile) = (args(0), args(1))

  // spark-submit command should supply all necessary config elements
  Runner.run(new SparkConf(), inputFile, outputFile)
}

object Runner {
  def run(conf: SparkConf, inputFile: String, outputFile: String): Unit = {
    conf.set("spark.hadoop.validateOutputSpecs", "false")
    val sc = new SparkContext(conf)
    val rdd = sc.textFile(inputFile)
    val counts = WordCount.withStopWordsFiltered(rdd)
    counts.saveAsTextFile(outputFile)
  }
}
