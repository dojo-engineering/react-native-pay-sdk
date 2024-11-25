#ifdef RCT_NEW_ARCH_ENABLED
#import "RNDojoReactNativePaySdkSpec.h"
#import "dojo_ios_sdk/dojo_ios_sdk-Swift.h"
#import "dojo_ios_sdk_drop_in_ui/dojo_ios_sdk_drop_in_ui-Swift.h"
#else
@import dojo_ios_sdk;
@import dojo_ios_sdk_drop_in_ui;
#endif

@interface DojoReactNativePaySdkConfig : NSObject
#ifdef RCT_NEW_ARCH_ENABLED
- (id) initWithDetails: (JS::NativeDojoReactNativePaySdk::PaymentDetails &)details;
#else
- (id) initWithDetails: (NSDictionary *)details;
#endif
- (NSString *)resolveIntentId;
- (NSString *)resolveCustomerSecret;
- (NSDate *)resolveMustCompleteBy;
- (DojoUIApplePayConfig *) resolveApplePayConfig;
- (DojoSDKDebugConfig *) resolveDebugConfig;
- (DojoThemeSettings *) resolveThemeSettings;
@end
