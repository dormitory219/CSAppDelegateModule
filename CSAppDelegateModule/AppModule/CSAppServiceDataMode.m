//
//  CSAppServiceDataMode.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/8/14.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppServiceDataMode.h"

@implementation CSAppServiceDataMode

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldInterrupt = NO;
        self.boolValue = NO;
    }
    return self;
}

@end
