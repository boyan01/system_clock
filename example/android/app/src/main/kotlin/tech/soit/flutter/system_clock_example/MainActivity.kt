package tech.soit.flutter.system_clock_example

import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import kotlin.concurrent.thread
import kotlin.time.DurationUnit
import kotlin.time.ExperimentalTime
import kotlin.time.toDuration

class MainActivity : FlutterActivity() {

  companion object {
    private const val TAG = "MainActivity"
  }

  @ExperimentalTime
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    thread {
      while (!Thread.interrupted()) {
        val uptime = SystemClock.uptimeMillis().toDuration(DurationUnit.MILLISECONDS)
        val elapsedRealtime = SystemClock.elapsedRealtime().toDuration(DurationUnit.MILLISECONDS)
        Log.d(TAG, "uptime = $uptime , elapsedRealtime = $elapsedRealtime")
        Thread.sleep(1000)
      }
    }
  }

}
