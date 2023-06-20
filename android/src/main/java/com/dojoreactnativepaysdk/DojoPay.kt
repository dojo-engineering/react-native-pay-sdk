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
  var activePromise: Promise? = null
  var UIHandler: DojoPaymentFlowHandler? = null
  var timer: Timer? = null

  @JvmStatic
  fun init(activity: ComponentActivity) {
    UIHandler = DojoSDKDropInUI.createUIPaymentHandler(activity) { result ->
      timer?.cancel()
      activePromise?.let { promise ->
        promise.resolve(result.code)
      }
      activePromise = null
    }
  }

  fun startExpiryTimer(expiryTime: String, context: ReactApplicationContext) {
    timer = Timer()
    val dateToRun = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX").parse(expiryTime)
    timer?.schedule(object : TimerTask() {
      override fun run() {
        // bring react native back to foreground
        context.currentActivity?.runOnUiThread {
          run() {
            if (context.currentActivity != null) {
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
