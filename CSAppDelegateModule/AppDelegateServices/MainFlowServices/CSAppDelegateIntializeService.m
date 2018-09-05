//
//  CSAppDelegateIntializeService.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateIntializeService.h"
#import <UIKit/UIKit.h>
#import "CSMediator.h"

@interface CSAppDelegateIntializeService()<CSAppDelegateServiceProtocol>


@end

@implementation CSAppDelegateIntializeService
@synthesize priority = _priority;


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [CSMediator registerService:@protocol(CSAppDelegateIntializeServiceProtocol) withImpl:self];
    }
    return self;
}

- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions;
{
    NSLog(@"------------CSAppDelegateModule: pre-launchApp begin:first initialize----------------");

    NSLog(@"------------CSAppDelegateModule:pre-launchApp end:finish initialize----------------");
    return YES;
}



@end
