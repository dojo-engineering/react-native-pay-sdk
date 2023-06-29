#import "DojoReactNativePaySdk.h"
#import <React/RCTUtils.h>
@import dojo_ios_sdk;
@import dojo_ios_sdk_drop_in_ui;

@implementation DojoReactNativePaySdk
RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(startPaymentFlow, startPaymentFlow
                 : (NSDictionary*)details resolve
                 : (RCTPromiseResolveBlock)resolve reject
                 : (RCTPromiseRejectBlock)reject) {
    
    DojoSDKDropInUI *dojoUI = [[DojoSDKDropInUI alloc] init];
    
    UIViewController *vc = RCTPresentedViewController();
    
    NSString *applePayMerchantId = details[@"applePayMerchantId"];
    NSString *intentId = details[@"intentId"];
    NSString *customerSecret = details[@"customerSecret"];
    NSNumber *darkTheme = details[@"darkTheme"];
    NSNumber *isProduction = details[@"isProduction"];
    
    DojoUIApplePayConfig *applePayConfig = nil;
    if (applePayMerchantId != nil) {
        applePayConfig = [[DojoUIApplePayConfig alloc]
                          initWithMerchantIdentifier:applePayMerchantId];
    }
    
    
    
    
    DojoSDKDebugConfig *debugConfig;
    if (isProduction != nil && isProduction.boolValue == false) {
        DojoSDKURLConfig *urlConfig = [[DojoSDKURLConfig alloc]
                                       initWithConnectE: @"https://web.e.test.connect.paymentsense.cloud"
                                       remote: @"https://staging-api.dojo.dev/master"];
        debugConfig = [[DojoSDKDebugConfig alloc]
                       initWithUrlConfig:urlConfig
                       isSandboxIntent:true
                       isSandboxWallet:true];
    }
    
    
    DojoThemeSettings *theme;
    if (darkTheme != nil && darkTheme.boolValue == true) {
        theme = [DojoThemeSettings getDarkTheme];
    } else {
        theme = [DojoThemeSettings getLightTheme];
    }
    
    [dojoUI startPaymentFlowWithPaymentIntentId:intentId
                                     controller:vc
                                 customerSecret:customerSecret
                                 applePayConfig:applePayConfig
                                  themeSettings:theme
                                    debugConfig:debugConfig
                                     completion:^(NSInteger result) {
        NSLog(@"%ld", (long)result);
        resolve(@(result));
    }];
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeDojoReactNativePaySdkSpecJSI>(
                                                                                 params);
}
#endif

@end
