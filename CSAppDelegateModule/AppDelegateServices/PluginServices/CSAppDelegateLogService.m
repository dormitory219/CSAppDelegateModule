//
//  CSAppDelegateLogService.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateLogService.h"
#import "CSMediator.h"
#import <UIKit/UIKit.h>

@implementation CSAppDelegateLogService
@synthesize priority = _priority;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [CSMediator registerService:@protocol(CSAppDelegateLogServiceProtocol) withImpl:self];
    }
    return self;
}

#pragma mark CSAppDelegateServiceProtocol
- (BOOL)applicationWillEnterForeground:(UIApplication *)application
{
    return NO;
}

- (BOOL)applicationDidEnterBackground:(UIApplication *)application
{
    return NO;
}

@end
