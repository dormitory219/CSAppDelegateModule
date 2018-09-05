//
//  CSServiceModule.m
//  CSMediator_Example
//
//  Created by joy_yu on 2018/5/10.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import "CSServiceModule.h"
#import "CSMediator.h"
#import "CSServiceModuleProtocol.h"

@implementation CSServiceModule

+ (void)load
{
    @autoreleasepool {
       // [CSMediator registerService:@protocol(CSServiceModuleProtocol)  withImpl:self];
    }
}

//do sth

@end
