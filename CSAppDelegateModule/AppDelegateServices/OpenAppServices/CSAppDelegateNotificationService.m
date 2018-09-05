//
//  CSAppDelegateNotificationService.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateNotificationService.h"
#import <UserNotifications/UserNotifications.h>
#import "CSMediator.h"
#import <UIKit/UIKit.h>

@interface CSAppDelegateNotificationService() <UNUserNotificationCenterDelegate>

@property (nonatomic,strong) UNUserNotificationCenter *notificationCenter;
@end

@implementation CSAppDelegateNotificationService
@synthesize priority = _priority;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [CSMediator registerService:@protocol(CSAppDelegateNotificationServiceProtocol) withImpl:self];
    }
    return self;
}

#pragma mark CSAppDelegateServiceProtocol
- (void)application:(UIApplication *) app didReceiveRemoteNotification:(NSDictionary *) userInfo
{
    NSLog(@"didReceiveRemoteNotification:%@", userInfo);
}


- (void)application:(UIApplication *) app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken
{
 
}

- (void)application:(UIApplication *) app didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    NSLog(@"Error when register for APNS: %@.", error);
}

- (void)applicationDidBecomeActive:(UIApplication *) application
{

}

- (BOOL)applicationWillEnterForeground:(UIApplication *)application
{
    return NO;
}


@end
