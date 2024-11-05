package com.dojoreactnativepaysdk

import com.facebook.react.bridge.*
import tech.dojo.pay.sdk.DojoPaymentResult
import tech.dojo.pay.sdk.card.entities.DojoGPayConfig
import tech.dojo.pay.sdk.card.entities.DojoSDKDebugConfig
import tech.dojo.pay.sdk.card.entities.DojoSDKURLConfig
import tech.dojo.pay.uisdk.DojoSDKDropInUI
import tech.dojo.pay.uisdk.entities.DojoPaymentFlowParams
import tech.dojo.pay.uisdk.entities.DojoPaymentType
import tech.dojo.pay.uisdk.entities.DojoThemeSettings
import tech.dojo.pay.uisdk.entities.LightColorPalette
import tech.dojo.pay.uisdk.entities.DarkColorPalette

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
    val showBranding =
      if (details.hasKey(SHOW_BRANDING)) details.getBoolean(SHOW_BRANDING) else true
    val mustCompleteBy = details.getString(MUST_COMPLETE_BY)
    var backdropViewColor = details.getString(BACKDROP_VIEW_COLOR)
    var backdropViewAlpha = 
    if (details.hasKey(BACKDROP_VIEW_ALPHA)) details.getDouble(BACKDROP_VIEW_ALPHA) else null

    val additionalLegalText = details.getString(ADDITIONAL_LEGAL_TEXT)
    val customCardDetailsNavigationTitle = details.getString(CUSTOM_CARD_DETAILS_NAVIGATION_TITLE)
    val customResultScreenTitleSuccess = details.getString(CUSTOM_RESULT_TITLE_SCREEN_SUCCESS)
    val customResultScreenTitleFail = details.getString(CUSTOM_RESULT_TITLE_FAIL)
    val customResultScreenOrderIdText = details.getString(CUSTOM_RESULT_ORDER_ID_TEXT)
    val customResultScreenMainTextSuccess = details.getString(CUSTOM_RESULT_MAIN_TEXT_SUCCESS)
    val customResultScreenMainTextFail = details.getString(CUSTOM_RESULT_MAIN_TEXT_FAIL)
    val customResultScreenAdditionalTextSuccess = details.getString(CUSTOM_RESULT_ADDITIONAL_TEXT_SUCCESS)
    val customResultScreenAdditionalTextFail = details.getString(CUSTOM_RESULT_ADDITIONAL_TEXT_FAIL)

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
      promise.resolve(DojoPaymentResult.INVALID_REQUEST.code)
      return
    }

    if (DojoPay.UIHandler == null) {
      promise.resolve(DojoPaymentResult.SDK_INTERNAL_ERROR.code)
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
    var lightColorPalette = LightColorPalette()
    var darkColorPalette = DarkColorPalette()
    var backdropViewAlphaFloat = 0f
    if (!backdropViewColor.isNullOrEmpty()) {
      // Android theme colour is in format #00 00 00 00 where first 00 is alpha
      // But we take as a parameter simple HEX so a small modification is needed
      backdropViewColor = backdropViewColor.removePrefix("#")
      backdropViewColor = "#FF$backdropViewColor"
    } else {
      backdropViewColor = lightColorPalette.backdropViewColor // same as for darkColorPalette
    }

    if (backdropViewAlpha !== null && backdropViewAlpha > 0) {
      backdropViewAlphaFloat = backdropViewAlpha.toFloat()
    } else {
      backdropViewAlphaFloat = lightColorPalette.backdropViewAlpha // same as for darkColorPalette
    }

    lightColorPalette = LightColorPalette(backdropViewColor = backdropViewColor, backdropViewAlpha = backdropViewAlphaFloat)
    darkColorPalette = DarkColorPalette(backdropViewColor = backdropViewColor, backdropViewAlpha = backdropViewAlphaFloat)    
    DojoSDKDropInUI.dojoThemeSettings = DojoThemeSettings(lightColorPalette = lightColorPalette, darkColorPalette = darkColorPalette, forceLightMode = forceLightMode, showBranding = showBranding)

    if (!additionalLegalText.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.additionalLegalText = additionalLegalText
    }

    if (!customCardDetailsNavigationTitle.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customCardDetailsNavigationTitle = customCardDetailsNavigationTitle
    }

    if (!customResultScreenTitleSuccess.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenTitleSuccess = customResultScreenTitleSuccess
    }

    if (!customResultScreenTitleFail.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenTitleFail = customResultScreenTitleFail
    }

    if (!customResultScreenOrderIdText.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenOrderIdText = customResultScreenOrderIdText
    }

    if (!customResultScreenMainTextSuccess.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenMainTextSuccess = customResultScreenMainTextSuccess
    }

    if (!customResultScreenMainTextFail.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenMainTextFail = customResultScreenMainTextFail
    }

    if (!customResultScreenAdditionalTextSuccess.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenAdditionalTextSuccess = customResultScreenAdditionalTextSuccess
    }

    if (!customResultScreenAdditionalTextFail.isNullOrEmpty()) {
      DojoSDKDropInUI.dojoThemeSettings?.customResultScreenAdditionalTextFail = customResultScreenAdditionalTextFail
    }

    if (mustCompleteBy != null) {
      DojoPay.startExpiryTimer(mustCompleteBy, reactApplicationContext)
    }

    DojoPay.activePromise = promise

    DojoPay.UIHandler?.startPaymentFlow(
      DojoPaymentFlowParams(
        paymentId = intentId,
        clientSecret = customerSecret,
        GPayConfig = gPayConfig
      )
    )
  }

  @ReactMethod
  override fun startSetupFlow(details: ReadableMap, promise: Promise) {
    val intentId = details.getString(INTENT_ID)
    val forceLightMode = if (details.hasKey(FORCE_LIGHT_MODE)) details.getBoolean(FORCE_LIGHT_MODE) else false
    val isProduction = if (details.hasKey(IS_PRODUCTION)) details.getBoolean(IS_PRODUCTION) else true
    val showBranding =
      if (details.hasKey(SHOW_BRANDING)) details.getBoolean(SHOW_BRANDING) else true
    val mustCompleteBy = details.getString(MUST_COMPLETE_BY)
    var backdropViewColor = details.getString(BACKDROP_VIEW_COLOR)
    var backdropViewAlpha = 
    if (details.hasKey(BACKDROP_VIEW_ALPHA)) details.getDouble(BACKDROP_VIEW_ALPHA) else null

    if (intentId.isNullOrEmpty()) {
      promise.resolve(DojoPaymentResult.INVALID_REQUEST.code)
      return
    }

    if (DojoPay.UIHandler == null) {
      promise.resolve(DojoPaymentResult.SDK_INTERNAL_ERROR.code)
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
    var lightColorPalette = LightColorPalette()
    var darkColorPalette = DarkColorPalette()
    var backdropViewAlphaFloat = 0f
    if (!backdropViewColor.isNullOrEmpty()) {
      // Android theme colour is in format #00 00 00 00 where first 00 is alpha
      // But we take as a parameter simple HEX so a small modification is needed
      backdropViewColor = backdropViewColor.removePrefix("#")
      backdropViewColor = "#FF$backdropViewColor"
    } else {
      backdropViewColor = lightColorPalette.backdropViewColor // same as for darkColorPalette
    }

    if (backdropViewAlpha !== null && backdropViewAlpha > 0) {
      backdropViewAlphaFloat = backdropViewAlpha.toFloat()
    } else {
      backdropViewAlphaFloat = lightColorPalette.backdropViewAlpha // same as for darkColorPalette
    }

    lightColorPalette = LightColorPalette(backdropViewColor = backdropViewColor, backdropViewAlpha = backdropViewAlphaFloat)
    darkColorPalette = DarkColorPalette(backdropViewColor = backdropViewColor, backdropViewAlpha = backdropViewAlphaFloat)    
    DojoSDKDropInUI.dojoThemeSettings = DojoThemeSettings(lightColorPalette = lightColorPalette, darkColorPalette = darkColorPalette, forceLightMode = forceLightMode, showBranding = showBranding)
    
    if (mustCompleteBy != null) {
      DojoPay.startExpiryTimer(mustCompleteBy, reactApplicationContext)
    }

    DojoPay.activePromise = promise

    DojoPay.UIHandler?.startPaymentFlow(
      DojoPaymentFlowParams(
        paymentId = intentId,
        paymentType = DojoPaymentType.SETUP_INTENT
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
    const val SHOW_BRANDING = "showBranding"
    const val MUST_COMPLETE_BY = "mustCompleteBy"
    const val ADDITIONAL_LEGAL_TEXT = "additionalLegalText"
    const val BACKDROP_VIEW_COLOR = "backdropViewColor"
    const val BACKDROP_VIEW_ALPHA = "backdropViewAlpha"


    const val CUSTOM_CARD_DETAILS_NAVIGATION_TITLE = "customCardDetailsNavigationTitle"
    const val CUSTOM_RESULT_TITLE_SCREEN_SUCCESS = "customResultScreenTitleSuccess"
    const val CUSTOM_RESULT_TITLE_FAIL = "customResultScreenTitleFail"
    const val CUSTOM_RESULT_ORDER_ID_TEXT = "customResultScreenOrderIdText"
    const val CUSTOM_RESULT_MAIN_TEXT_SUCCESS = "customResultScreenMainTextSuccess"
    const val CUSTOM_RESULT_MAIN_TEXT_FAIL = "customResultScreenMainTextFail"
    const val CUSTOM_RESULT_ADDITIONAL_TEXT_SUCCESS = "customResultScreenAdditionalTextSuccess"
    const val CUSTOM_RESULT_ADDITIONAL_TEXT_FAIL = "customResultScreenAdditionalTextFail"
  }
}
