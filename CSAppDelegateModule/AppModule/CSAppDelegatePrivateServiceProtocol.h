//
//  CSAppDelegatePrivateServiceProtocol.h
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/8/8.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#ifndef CSAppDelegatePrivateServiceProtocol_h
#define CSAppDelegatePrivateServiceProtocol_h
#import <UIKit/UIKit.h>

@class CSAppServiceDataMode;
@protocol CSAppDelegateServiceProtocol <NSObject>

@property (nonatomic,assign) NSInteger priority;

@optional

- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions;

- (CSAppServiceDataMode *)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (CSAppServiceDataMode *)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * restorableObjects))restorationHandler;

- (CSAppServiceDataMode *)application:(UIApplication *) application performActionForShortcutItem:(UIApplicationShortcutItem *) shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler;

- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo;

//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

- (void)application:(UIApplication *) app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken;

- (void)applicationDidBecomeActive:(UIApplication *) application;

- (void)applicationWillResignActive:(UIApplication *) application;

- (void)applicationWillTerminate:(UIApplication *)application;

- (BOOL)applicationDidEnterBackground:(UIApplication *)application;

- (BOOL)applicationWillEnterForeground:(UIApplication *)application;

@end

@protocol CSAppDelegateMainFlowServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateForceUpdateServiceProtocol <CSAppDelegateServiceProtocol>


@end

@protocol CSAppDelegateCrashCollectionServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateDataBaseMigrationServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateRecoveryServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDeleagateUploadAppListServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateApperanceServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateExtensionServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateIntializeServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateLaunchADServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateLaunchScreenServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateLogServiceProtocol <CSAppDelegateServiceProtocol>

@end


@protocol CSAppDelegateNotificationServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegatePasswordProtectServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateShortcutOperationServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegateViewControllerServiceProtocol <CSAppDelegateServiceProtocol>



@end


@protocol CSAppDelegateFinishStartupServiceProtocol <CSAppDelegateServiceProtocol>


@end

@protocol CSAppDelegateOpenPDFServiceProtocol <CSAppDelegateServiceProtocol>


@end


@protocol CSAppDelegatePrivateServiceProtocol <CSAppDelegateMainFlowServiceProtocol,CSAppDelegateIntializeServiceProtocol,CSAppDelegateForceUpdateServiceProtocol,CSAppDelegateCrashCollectionServiceProtocol,CSAppDelegateDataBaseMigrationServiceProtocol,CSAppDelegateRecoveryServiceProtocol,CSAppDeleagateUploadAppListServiceProtocol,CSAppDelegateApperanceServiceProtocol,CSAppDelegateExtensionServiceProtocol,CSAppDelegateLaunchADServiceProtocol,CSAppDelegateLaunchScreenServiceProtocol,CSAppDelegateLogServiceProtocol,CSAppDelegateNotificationServiceProtocol,CSAppDelegatePasswordProtectServiceProtocol,CSAppDelegateShortcutOperationServiceProtocol,CSAppDelegateViewControllerServiceProtocol,CSAppDelegateOpenPDFServiceProtocol>
@end



#endif /* CSAppDelegatePrivateServiceProtocol_h */
