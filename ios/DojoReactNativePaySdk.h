#import "DojoReactNativePaySdkConfig.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNDojoReactNativePaySdkSpec.h"

@interface DojoReactNativePaySdk : NSObject <NativeDojoReactNativePaySdkSpec>
#else
#import <React/RCTBridge.h>

@interface DojoReactNativePaySdk : NSObject <RCTBridgeModule>
#endif

@end



