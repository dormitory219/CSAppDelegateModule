//
//  CSAppDelegateSpotlightService.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateSpotlightService.h"

#import <CoreSpotlight/CoreSpotlight.h>
#import "CSAppServiceDataMode.h"
#import "CSMediator.h"

@implementation CSAppDelegateSpotlightService
@synthesize priority = _priority;

#pragma mark CSAppDelegateServiceProtocol
- (CSAppServiceDataMode *)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * restorableObjects))restorationHandler
{
    CSAppServiceDataMode *data = [[CSAppServiceDataMode alloc] init];
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType])
    {

    }
    return data;
}


@end
