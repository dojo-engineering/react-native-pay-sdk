package com.dojoreactnativepaysdk

import com.facebook.react.bridge.*
import tech.dojo.pay.sdk.DojoPaymentResult
import tech.dojo.pay.sdk.DojoSdk
import tech.dojo.pay.sdk.card.entities.DojoGPayConfig
import tech.dojo.pay.sdk.card.entities.DojoSDKDebugConfig
import tech.dojo.pay.sdk.card.entities.DojoSDKURLConfig
import tech.dojo.pay.uisdk.DojoSDKDropInUI
import tech.dojo.pay.uisdk.entities.DojoPaymentFlowParams
import tech.dojo.pay.uisdk.entities.DojoThemeSettings

class DojoReactNativePaySdkModule internal constructor(context: ReactApplicationContext) :
  DojoReactNativePaySdkSpec(context) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun startPaymentFlow(details: ReadableMap, promise: Promise) {
    val intentId = details.getString(INTENT_ID)
    val customerSecret = details.getString(CUSTOMER_SECRET)
    val gPayMerchantId = details.getString(GOOGLE_PAY_MERCHANT_ID)
    val gPayMerchantName = details.getString(GOOGLE_PAY_MERCHANT_NAME)
    val gPayGatewayMerchantId = details.getString(GOOGLE_PAY_GATEWAY_MERCHANT_ID)
    val forceLightMode = if (details.hasKey(FORCE_LIGHT_MODE)) details.getBoolean(FORCE_LIGHT_MODE) else false
    val isProduction = if (details.hasKey(IS_PRODUCTION)) details.getBoolean(IS_PRODUCTION) else true

    val gPayConfig = if (
      gPayMerchantId !== null &&
      gPayMerchantName !== null &&
      gPayGatewayMerchantId !== null
    ) DojoGPayConfig(
      merchantName = gPayMerchantName,
      merchantId = gPayMerchantId,
      gatewayMerchantId = gPayGatewayMerchantId
    ) else null

    if (intentId.isNullOrEmpty()) {
      promise.resolve(DojoPaymentResult.INVALID_REQUEST)
      return
    }

    if (DojoPay.dojoPayUI == null) {
      promise.resolve(DojoPaymentResult.SDK_INTERNAL_ERROR)
      return
    }

    val urlConfig = if (!isProduction) DojoSDKURLConfig(
      "https://web.e.test.connect.paymentsense.cloud/",
      "https://staging-api.dojo.dev/master/",
    ) else null

    var debugConfig = if (!isProduction) DojoSDKDebugConfig(
      urlConfig,
      true,
      true
    ) else null

    DojoSDKDropInUI.dojoSDKDebugConfig = debugConfig
    DojoSDKDropInUI.dojoThemeSettings = DojoThemeSettings(forceLightMode = forceLightMode)

    DojoPay.activePromise = promise

    DojoPay.dojoPayUI?.startPaymentFlow(
      DojoPaymentFlowParams(
        paymentId = intentId,
        clientSecret = customerSecret,
        GPayConfig = gPayConfig
      )
    )
  }

  companion object {
    const val NAME = "DojoReactNativePaySdk"
    const val INTENT_ID = "intentId"
    const val CUSTOMER_SECRET = "customerSecret"
    const val IS_PRODUCTION = "isProduction"
    const val FORCE_LIGHT_MODE = "forceLightMode"
    const val GOOGLE_PAY_MERCHANT_ID = "gPayMerchantId"
    const val GOOGLE_PAY_GATEWAY_MERCHANT_ID = "gPayGatewayMerchantId"
    const val GOOGLE_PAY_MERCHANT_NAME = "gPayMerchantName"
  }
}
