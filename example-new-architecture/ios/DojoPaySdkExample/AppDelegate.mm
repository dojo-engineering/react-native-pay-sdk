#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"DojoReactNativePaySdkExample";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (UISceneConfiguration *)application:(UIApplication *)application
    configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                                   options:(UISceneConnectionOptions *)options
{
  return [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                        sessionRole:connectingSceneSession.role];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
    willConnectToSession:(UISceneSession *)session
                 options:(UISceneConnectionOptions *)connectionOptions
{
  if (![scene isKindOfClass:[UIWindowScene class]]) {
    return;
  }

  AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
  UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
  window.rootViewController = appDelegate.window.rootViewController;
  appDelegate.window = window;
  self.window = window;
  [window makeKeyAndVisible];
}

@end
