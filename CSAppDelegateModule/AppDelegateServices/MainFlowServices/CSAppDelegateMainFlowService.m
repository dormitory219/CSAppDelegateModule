//
//  CSAppDelegateMainFlowService.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateMainFlowService.h"
#import "CSMediator.h"
#import "CSAppDelegatePrivateServiceProtocol.h"
#import <UIKit/UIKit.h>

@implementation CSAppDelegateMainFlowService
@synthesize priority = _priority;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [CSMediator registerService:@protocol(CSAppDelegateMainFlowServiceProtocol) withImpl:self];
    }
    return self;
}

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    NSLog(@"**********CSAppDelegateModule: Start Launch**********");
    return YES;
}

@end
