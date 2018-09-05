//
//  CSAppDelegateModule.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/10.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateModule.h"
#import "CSAppDelegateModuleProxy.h"
#import "CSMediator.h"
#import "CSAppDelegateModulePublicProtocol.h"
#import "CSAppDelegatePrivateServiceProtocol.h"

@implementation CSAppDelegateModule

+(void)load
{
    [CSMediator registerService:@protocol(CSAppDelegateModuleProtocol) withImpl: [[self alloc] init]];
}

/*
 CSAppDelegateModule模块业务防crash机制,目前主要针对CSAppDelegateModule类：
 原则上是为防止测试环境case未被全部覆盖，导致线上crash而作用，所以debug环境下尽管crash让我修bug吧，线上就强行不挂
 使用一个桩对象CSAppDelegateModuleProxy来转发方法
 */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    #ifdef DEBUG
    NSLog(@"CSAppDelegateModule did crash for selector:<<%@>>!!!!!",NSStringFromSelector(aSelector));
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"CSAppDelegateModule crash for selector:<<%@>>",NSStringFromSelector(aSelector)] userInfo:nil];
    return nil;
    #else
    ISError(@"CSAppDelegateModule will crash for<< %@ >>,CSAppDelegateModuleProxy will handle this to prevent crash!!!!!",NSStringFromSelector(aSelector));
    return [CSAppDelegateModuleProxy ProxyforwardingTargetForSelector:aSelector];
    #endif
}

#pragma mark CSAppDelegateServiceManagerProtocol

- (void)setWindow:(UIWindow *)window
{
    id <CSAppDelegateServiceManagerProtocol> service = [CSMediator serviceForProtocol:@protocol(CSAppDelegateServiceManagerProtocol)];
    [service setWindow:window];
}

- (UIWindow *)window
{
    id <CSAppDelegateServiceManagerProtocol> service = [CSMediator serviceForProtocol:@protocol(CSAppDelegateServiceManagerProtocol)];
    return service.window;
}

@end
