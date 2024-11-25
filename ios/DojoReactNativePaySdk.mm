#import "DojoReactNativePaySdk.h"
#import <React/RCTUtils.h>

@implementation DojoReactNativePaySdk

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

int EXPIRED_RESULT_CODE = 40;


#ifdef RCT_NEW_ARCH_ENABLED
RCT_REMAP_METHOD(startPaymentFlow,
                 startPaymentFlow: (JS::NativeDojoReactNativePaySdk::PaymentDetails &)details
                 resolve: (RCTPromiseResolveBlock)resolve
                 reject: (RCTPromiseRejectBlock)reject)
#else
RCT_REMAP_METHOD(startPaymentFlow,
                 startPaymentFlow: (NSDictionary *)details
                 resolve: (RCTPromiseResolveBlock)resolve
                 reject: (RCTPromiseRejectBlock)reject)
#endif
{
  DojoReactNativePaySdkConfig *config = [[DojoReactNativePaySdkConfig alloc] initWithDetails: details];
  
  DojoSDKDropInUI *dojoUI = [[DojoSDKDropInUI alloc] init];
  UIViewController *vc = RCTPresentedViewController();
  
  NSTimer *expiryTimer = nil;
  NSDate *mustCompleteBy = [config resolveMustCompleteBy];
  if (mustCompleteBy != nil) {
    expiryTimer = [[NSTimer alloc] initWithFireDate:mustCompleteBy interval:0 repeats:false block:^(NSTimer * _Nonnull timer) {
      if (expiryTimer != nil) {
        [expiryTimer invalidate];
      }
      [vc dismissViewControllerAnimated:YES completion:nil];
      resolve(@(EXPIRED_RESULT_CODE));
    }];
    
    [[NSRunLoop mainRunLoop] addTimer: expiryTimer forMode:NSDefaultRunLoopMode];
  }
  
  [dojoUI startPaymentFlowWithPaymentIntentId:[config resolveIntentId]
                                   controller:vc
                               customerSecret:[config resolveCustomerSecret]
                               applePayConfig:[config resolveApplePayConfig]
                                themeSettings:[config resolveThemeSettings]
                                  debugConfig:[config resolveDebugConfig]
                                   completion:^(NSInteger result) {
    if (expiryTimer != nil) {
      [expiryTimer invalidate];
    }
    
    resolve(@(result));
  }];
}

#ifdef RCT_NEW_ARCH_ENABLED
RCT_REMAP_METHOD(startSetupFlow,
                 startSetupFlow: (JS::NativeDojoReactNativePaySdk::PaymentDetails &)details
                 resolve: (RCTPromiseResolveBlock)resolve
                 reject: (RCTPromiseRejectBlock)reject)
#else
RCT_REMAP_METHOD(startSetupFlow,
                 startSetupFlow: (NSDictionary *)details
                 resolve: (RCTPromiseResolveBlock)resolve
                 reject: (RCTPromiseRejectBlock)reject)
#endif
{
  DojoReactNativePaySdkConfig *config = [[DojoReactNativePaySdkConfig alloc] initWithDetails: details];
  DojoSDKDropInUI *dojoUI = [[DojoSDKDropInUI alloc] init];
  UIViewController *vc = RCTPresentedViewController();
  
  NSTimer *expiryTimer = nil;
  NSDate *mustCompleteBy = [config resolveMustCompleteBy];
  if (mustCompleteBy != nil) {
    expiryTimer = [[NSTimer alloc] initWithFireDate:mustCompleteBy interval:0 repeats:false block:^(NSTimer * _Nonnull timer) {
      if (expiryTimer != nil) {
        [expiryTimer invalidate];
      }
      [vc dismissViewControllerAnimated:YES completion:nil];
      resolve(@(EXPIRED_RESULT_CODE));
    }];
    
    [[NSRunLoop mainRunLoop] addTimer: expiryTimer forMode:NSDefaultRunLoopMode];
  }
  
  [dojoUI startSetupFlowWithSetupIntentId:[config resolveIntentId]
                               controller:vc
                            themeSettings:[config resolveThemeSettings]
                              debugConfig:[config resolveDebugConfig]
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
