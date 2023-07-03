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

int EXPIRED_RESULT_CODE = 40;

RCT_REMAP_METHOD(startPaymentFlow, startPaymentFlow
                 : (NSDictionary*)details resolve
                 : (RCTPromiseResolveBlock)resolve reject
                 : (RCTPromiseRejectBlock)reject) {
    
    DojoSDKDropInUI *dojoUI = [[DojoSDKDropInUI alloc] init];
    UIViewController *vc = RCTPresentedViewController();
    NSTimer *expiryTimer = nil;
    
    NSString *applePayMerchantId = details[@"applePayMerchantId"];
    NSString *intentId = details[@"intentId"];
    NSString *customerSecret = details[@"customerSecret"];
    NSNumber *darkTheme = details[@"darkTheme"];
    NSNumber *isProduction = details[@"isProduction"];
    NSNumber *showBranding = details[@"showBranding"];
    NSString *mustCompleteBy = details[@"mustCompleteBy"];
    
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
    
    if (showBranding != nil && showBranding.boolValue == false) {
        [theme setShowBranding:@false];
    }
    
    if (mustCompleteBy != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        NSDate *date = [dateFormatter dateFromString:mustCompleteBy];
        
        expiryTimer = [[NSTimer alloc] initWithFireDate:date interval:0 repeats:false block:^(NSTimer * _Nonnull timer) {
            if (expiryTimer != nil) {
                [expiryTimer invalidate];
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
            resolve(@(EXPIRED_RESULT_CODE));
        }];
        
        [[NSRunLoop mainRunLoop] addTimer: expiryTimer forMode:NSDefaultRunLoopMode];
    }
    
    [dojoUI startPaymentFlowWithPaymentIntentId:intentId
                                     controller:vc
                                 customerSecret:customerSecret
                                 applePayConfig:applePayConfig
                                  themeSettings:theme
                                    debugConfig:debugConfig
                                     completion:^(NSInteger result) {
        if (expiryTimer != nil) {
            [expiryTimer invalidate];
        }
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
