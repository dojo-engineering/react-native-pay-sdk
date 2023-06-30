package com.dojoreactnativepaysdk

import android.content.Intent
import androidx.activity.ComponentActivity
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import tech.dojo.pay.uisdk.DojoSDKDropInUI
import tech.dojo.pay.uisdk.presentation.handler.DojoPaymentFlowHandler
import java.text.SimpleDateFormat
import java.util.*


object DojoPay {
  private const val EXPIRED_RESULT_CODE: Int = 40;

  var activePromise: Promise? = null
  var UIHandler: DojoPaymentFlowHandler? = null
  private var timer: Timer? = null
  private var hasExpired: Boolean = false

  @JvmStatic
  fun init(activity: ComponentActivity) {
    UIHandler = DojoSDKDropInUI.createUIPaymentHandler(activity) { result ->
      timer?.cancel()
      activePromise?.let { promise ->
        val code = if (hasExpired) EXPIRED_RESULT_CODE else result.code
        promise.resolve(code)
      }
      activePromise = null
      hasExpired = false
    }
  }

  fun startExpiryTimer(expiryTime: String, context: ReactApplicationContext) {
    timer = Timer()
    hasExpired = false
    val dateToRun = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX").parse(expiryTime)
    timer?.schedule(object : TimerTask() {
      override fun run() {
        // bring react native back to foreground
        context.currentActivity?.runOnUiThread {
          run() {
            if (context.currentActivity != null) {
              hasExpired = true
              val intent = Intent(context, context.currentActivity?.javaClass)
              intent.action = Intent.ACTION_MAIN
              intent.addCategory(Intent.CATEGORY_LAUNCHER)
              intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
              context.startActivity(intent)
            }
          }
        }
      }
    }, dateToRun)
  }
}
