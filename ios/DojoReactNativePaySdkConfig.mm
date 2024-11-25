#import "DojoReactNativePaySdkConfig.h"

@implementation DojoReactNativePaySdkConfig
#ifdef RCT_NEW_ARCH_ENABLED
JS::NativeDojoReactNativePaySdk::PaymentDetails *config;
#else
NSDictionary *config;
#endif

+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#ifdef RCT_NEW_ARCH_ENABLED
- (id) initWithDetails: (JS::NativeDojoReactNativePaySdk::PaymentDetails &)details
#else
- (id) initWithDetails: (NSDictionary *)details
#endif
{
  self = [super init];
  
  if (self) {
#ifdef RCT_NEW_ARCH_ENABLED
    config = &details;
#else
    config = details;
#endif
  }
  
  return self;
}

- (NSString *) applePayMerchantId {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->applePayMerchantId();
#else
  return config[@"applePayMerchantId"];
#endif
}

- (BOOL) isProduction {
#ifdef RCT_NEW_ARCH_ENABLED
  std::optional<bool> isProduction = config->isProduction();
  return !isProduction.has_value() || isProduction.value() == true;
#else
  NSNumber *isProduction = config[@"isProduction"];
  return isProduction == nil || isProduction.boolValue == true;
#endif
}

- (BOOL) useDarkTheme {
#ifdef RCT_NEW_ARCH_ENABLED
  std::optional<bool> darkTheme = config->darkTheme();
  return darkTheme.has_value() && darkTheme.value() == true;
#else
  NSNumber *darkTheme = config[@"darkTheme"];
  return darkTheme != nil && darkTheme.boolValue == true;
#endif
}

- (BOOL) showBranding {
#ifdef RCT_NEW_ARCH_ENABLED
  std::optional<bool> darkTheme = config->darkTheme();
  return !darkTheme.has_value() || darkTheme.value() == true;
#else
  NSNumber *showBranding = config[@"showBranding"];
  return showBranding == nil || showBranding.boolValue == true;
#endif
}

- (NSString *)additionalLegalText {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->additionalLegalText();
#else
  return config[@"additionalLegalText"];
#endif
}

- (NSString *)customCardDetailsNavigationTitle {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customCardDetailsNavigationTitle();
#else
  return config[@"customCardDetailsNavigationTitle"];
#endif
}

- (NSString *)customResultScreenTitleSuccess {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenTitleSuccess();
#else
  return config[@"customResultScreenTitleSuccess"];
#endif
}

- (NSString *)customResultScreenTitleFail {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenTitleFail();
#else
  return config[@"customResultScreenTitleFail"];
#endif
}

- (NSString *)customResultScreenOrderIdText {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenOrderIdText();
#else
  return config[@"customResultScreenOrderIdText"];
#endif
}

- (NSString *)customResultScreenMainTextSuccess {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenMainTextSuccess();
#else
  return config[@"customResultScreenMainTextSuccess"];
#endif
}

- (NSString *)customResultScreenMainTextFail {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenMainTextFail();
#else
  return config[@"customResultScreenMainTextFail"];
#endif
}

- (NSString *)customResultScreenAdditionalTextSuccess {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenAdditionalTextSuccess();
#else
  return config[@"customResultScreenAdditionalTextSuccess"];
#endif
}

- (NSString *)customResultScreenAdditionalTextFail {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customResultScreenAdditionalTextFail();
#else
  return config[@"customResultScreenAdditionalTextFail"];
#endif
}

- (NSString *)backdropViewColor {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->backdropViewColor();
#else
  return config[@"backdropViewColor"];
#endif
}

- (NSNumber *)backdropViewAlpha {
#ifdef RCT_NEW_ARCH_ENABLED
  std::optional<double> alpha = config->backdropViewAlpha();
  
  if (alpha.has_value()) {
    return [[NSNumber alloc] initWithDouble:alpha.value()];
  }
  
  return nil;
#else
  return config[@"backdropViewAlpha"];
#endif
}

- (NSString *)resolveIntentId {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->intentId();
#else
  return config[@"intentId"];
#endif
}

- (NSString *)resolveCustomerSecret {
#ifdef RCT_NEW_ARCH_ENABLED
  return config->customerSecret();
#else
  return config[@"customerSecret"];
#endif
}

- (NSDate *)resolveMustCompleteBy {
  NSString *timestamp = nil;
  
#ifdef RCT_NEW_ARCH_ENABLED
  timestamp = config->mustCompleteBy();
#else
  timestamp = config[@"mustCompleteBy"];
#endif
  
  if (timestamp == nil) {
    return nil;
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
  
  return [dateFormatter dateFromString:timestamp];
}

- (DojoUIApplePayConfig *) resolveApplePayConfig {
  DojoUIApplePayConfig *applePayConfig = nil;
  NSString *applePayMerchantId = [self applePayMerchantId];
  
  if (applePayMerchantId != nil) {
    applePayConfig = [[DojoUIApplePayConfig alloc]
                      initWithMerchantIdentifier:applePayMerchantId];
  }
  
  return applePayConfig;
}

- (DojoSDKDebugConfig *) resolveDebugConfig {
  DojoSDKDebugConfig *debugConfig;
  
  if (![self isProduction]) {
    DojoSDKURLConfig *urlConfig = [[DojoSDKURLConfig alloc]
                                   initWithConnectE: @"https://web.e.test.connect.paymentsense.cloud"
                                   remote: @"https://staging-api.dojo.dev/master"];
    
    debugConfig = [[DojoSDKDebugConfig alloc]
                   initWithUrlConfig:urlConfig
                   isSandboxIntent:true
                   isSandboxWallet:true];
  }
  
  return debugConfig;
}

- (DojoThemeSettings *) resolveThemeSettings {
  DojoThemeSettings *theme;
  
  if ([self useDarkTheme]) {
    theme = [DojoThemeSettings getDarkTheme];
  } else {
    theme = [DojoThemeSettings getLightTheme];
  }
  
  if ([self showBranding]) {
    [theme setShowBranding: @true];
  } else {
    [theme setShowBranding: @false];
  }
  
  NSString *additionalLegalText = [self additionalLegalText];
  if (additionalLegalText != nil && [additionalLegalText length] > 0) {
    [theme setAdditionalLegalText: additionalLegalText];
  }
  
  NSString *customCardDetailsNavigationTitle = [self customCardDetailsNavigationTitle];
  if (customCardDetailsNavigationTitle != nil && [customCardDetailsNavigationTitle length] > 0) {
    [theme setCustomCardDetailsNavigationTitle: customCardDetailsNavigationTitle];
  }
  
  NSString *customResultScreenTitleSuccess = [self customResultScreenTitleSuccess];
  if (customResultScreenTitleSuccess != nil && [customResultScreenTitleSuccess length] > 0) {
    [theme setCustomResultScreenTitleSuccess: customResultScreenTitleSuccess];
  }
  
  NSString *customResultScreenTitleFail = [self customResultScreenTitleFail];
  if (customResultScreenTitleFail != nil && [customResultScreenTitleFail length] > 0) {
    [theme setCustomResultScreenTitleFail: customResultScreenTitleFail];
  }
  
  NSString *customResultScreenOrderIdText = [self customResultScreenOrderIdText];
  if (customResultScreenOrderIdText != nil && [customResultScreenOrderIdText length] > 0) {
    [theme setCustomResultScreenOrderIdText: customResultScreenOrderIdText];
  }
  
  NSString *customResultScreenMainTextSuccess = [self customResultScreenMainTextSuccess];
  if (customResultScreenMainTextSuccess != nil && [customResultScreenMainTextSuccess length] > 0) {
    [theme setCustomResultScreenMainTextSuccess: customResultScreenMainTextSuccess];
  }
  
  NSString *customResultScreenMainTextFail = [self customResultScreenMainTextFail];
  if (customResultScreenMainTextFail != nil && [customResultScreenMainTextFail length] > 0) {
    [theme setCustomResultScreenMainTextFail: customResultScreenMainTextFail];
  }
  
  NSString *customResultScreenAdditionalTextSuccess = [self customResultScreenAdditionalTextSuccess];
  if (customResultScreenAdditionalTextSuccess != nil && [customResultScreenAdditionalTextSuccess length] > 0) {
    [theme setCustomResultScreenAdditionalTextSuccess: customResultScreenAdditionalTextSuccess];
  }
  
  NSString *customResultScreenAdditionalTextFail = [self customResultScreenAdditionalTextFail];
  if (customResultScreenAdditionalTextFail != nil && [customResultScreenAdditionalTextFail length] > 0) {
    [theme setCustomResultScreenAdditionalTextFail: customResultScreenAdditionalTextFail];
  }
  
  NSString *backdropViewColor = [self backdropViewColor];
  if (backdropViewColor != nil && [backdropViewColor length] > 0) {
    [theme setBackdropViewColor: [DojoReactNativePaySdkConfig colorFromHexString: backdropViewColor]];
  }
  
  NSNumber *backdropViewAlpha = [self backdropViewAlpha];
  if (backdropViewAlpha != nil && backdropViewAlpha.doubleValue > 0.0) {
    NSDecimalNumber *alpha = [[NSDecimalNumber alloc] initWithDouble:backdropViewAlpha.doubleValue];
    [theme setBackdropViewAlpha: alpha];
  }
  
  return theme;
}

@end
