//
//  CSAppDelegateDataBaseMigrationService.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateDataBaseMigrationService.h"
#import "CSAppServiceDataMode.h"
#import "CSMediator.h"
#import <UIKit/UIKit.h>

@implementation CSAppDelegateDataBaseMigrationService
@synthesize priority = _priority;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [CSMediator registerService:@protocol(CSAppDelegateDataBaseMigrationServiceProtocol) withImpl:self];
    }
    return self;
}

#pragma mark CSAppDelegateServiceProtocol
- (BOOL)applicationWillEnterForeground:(UIApplication *)application
{
    BOOL shouldInterrupt = NO;
    return shouldInterrupt;
}

- (CSAppServiceDataMode *)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    CSAppServiceDataMode *data = [[CSAppServiceDataMode alloc] init];

    return data;
}

- (CSAppServiceDataMode *) application:(UIApplication *) application performActionForShortcutItem:(UIApplicationShortcutItem *) shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler
{
    CSAppServiceDataMode *data = [[CSAppServiceDataMode alloc] init];
    return data;
}

- (CSAppServiceDataMode *)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * restorableObjects))restorationHandler
{
    CSAppServiceDataMode *data = [[CSAppServiceDataMode alloc] init];
    return data;
}

#pragma mark CSAppDelegateDataBaseMigrationServiceProtocol
- (BOOL)checkNeedToUpdateDataBase
{
    return YES;
}

@end
