//
//  AppDelegate.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/10.
//  Copyright © 2018年 余强. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "CSAppDelegateMainFlowService.h"
#import "CSAppDelegateDataBaseMigrationService.h"
#import "CSAppDelegateLogService.h"
#import "CSAppDelegateSpotlightService.h"
#import "CSAppDelegateIntializeService.h"
#import "CSAppDelegateServiceManager.h"
#import "CSAppDelegateModulePublicProtocol.h"

#import "CSMediator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    NSLog(@"CSAppDelegateModule: app did finish launching with option:%@",launchOptions);
    /*
     step1:
     创建app的window,内容viewController
     */
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    ViewController *viewController = [[ViewController alloc] init];
    self.window = window;
    
    /*
     step2:
     注册CSAppDelegateModule模块内需要加载的services服务列表
     */
    [[CSAppDelegateServiceManager shareManager] registerAllService];
    
    /*
     step3:
     将viewController,window注入到CSAppDelegateModule中，之后作为模块public访问
     */
    id<CSAppDelegateModuleProtocol>service = [CSMediator serviceForProtocol:@protocol(CSAppDelegateModuleProtocol)];
      service.window = window;
    
    /*
     step4:
     didFinishLaunchingWithOptions方法对services进行优先级预处理:
     CSAppDelegateIntializeService内部做很多相关初始化工作，优先级较高
     */
    [CSAppDelegateServiceManager shareManager].sortServices = @[
                                                                [CSAppDelegateIntializeService class],
                                                                [CSAppDelegateMainFlowService class],
                                                                ];
    
    /*
     step5:
     调用didFinishLaunchingWithOptions services服务
     */
    BOOL launch = [[CSAppDelegateServiceManager shareManager] application:application didFinishLaunchingWithOptions:launchOptions];
    if (!launch)
    {
        return NO;
    }
    
    /*
     step6:
     初始化可视窗口
     */
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"CSAppDelegateModule: application:%@, openURL: %@, sourceApplication: %@.", [application description], [url description], sourceApplication);
    //openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation方法对services进行优先级预处理
    [CSAppDelegateServiceManager shareManager].sortServices = @[
                                                                [CSAppDelegateDataBaseMigrationService class],
                                                                ];
    BOOL open = [[CSAppDelegateServiceManager shareManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return open;
}
#pragma clang diagnostic pop

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler
{
    NSLog(@"CSAppDelegateModule: application: %@.", [application description]);
    //continueUserActivity:(NSUserActivity *)userActivity restorationHandler方法对services进行优先级预处理
    [CSAppDelegateServiceManager shareManager].sortServices = @[
                                                                [CSAppDelegateDataBaseMigrationService class],
                                                                [CSAppDelegateSpotlightService class]
                                                                ];
    BOOL open = [[CSAppDelegateServiceManager shareManager] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    return open;
}

- (void)application:(UIApplication *) application performActionForShortcutItem:(UIApplicationShortcutItem *) shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler
{
    NSLog(@"CSAppDelegateModule: application: %@.", [application description]);
    //performActionForShortcutItem:(UIApplicationShortcutItem *) shortcutItem completionHandler进行优先级预处理
    [CSAppDelegateServiceManager shareManager].sortServices = @[
                                                                [CSAppDelegateDataBaseMigrationService class],
                                                                ];
    [[CSAppDelegateServiceManager shareManager] application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo
{
    NSLog(@"CSAppDelegateModule: application didReceiveRemoteNotification:%@", userInfo);
    [[CSAppDelegateServiceManager shareManager] application:application didReceiveRemoteNotification:userInfo];
}
#pragma clang diagnostic pop

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken
{
    NSLog(@"CSAppDelegateModule: did register deviceToken");
    
    [[CSAppDelegateServiceManager shareManager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)applicationDidBecomeActive:(UIApplication *) application
{
    NSLog(@"CSAppDelegateModule: Application: %@ did become active", [application description]);
    [[CSAppDelegateServiceManager shareManager] applicationDidBecomeActive:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"CSAppDelegateModule: Application: %@ will enter foreground", [application description]);
    //applicationWillEnterForeground:(UIApplication *)application进行优先级预处理
    [CSAppDelegateServiceManager shareManager].sortServices = @[
                  [CSAppDelegateDataBaseMigrationService class]
                                                                ];
    [[CSAppDelegateServiceManager shareManager] applicationWillEnterForeground:application];
}

- (void)applicationWillResignActive:(UIApplication *) application
{
    NSLog(@"CSAppDelegateModule: Application: %@ will resign active", [application description]);
    [[CSAppDelegateServiceManager shareManager] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"CSAppDelegateModule: application: %@ did enter background", [application description]);
    //applicationDidEnterBackground:(UIApplication *)application进行优先级预处理
    [CSAppDelegateServiceManager shareManager].sortServices = @[
                                                                ];
    [[CSAppDelegateServiceManager shareManager] applicationDidEnterBackground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"CSAppDelegateModule: application: %@ will resign terminate", [application description]);
    [[CSAppDelegateServiceManager shareManager] applicationWillTerminate:application];
}


@end
