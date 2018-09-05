//
//  CSMediator.m
//  CSMediator_Example
//
//  Created by joy_yu on 2018/5/10.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import "CSMediator.h"

@implementation CSMediator

@end

@implementation CSMediator(Router)

+ (void)registerRouterModule:(id<CSRouterModuleProtocol>)module
{
    [[CSRouter router] registerRouterModule:module];
}

+ (void)routerURL:(nonnull NSString *)urlString withParameter:(nullable NSDictionary *)parameter
{
    [[CSRouter router] routerURL:urlString withParameter:parameter];
}

@end

@implementation CSMediator(Service)

+ (void)registerService:(Protocol *)proto withImpl:(id)impl
{
    [[CSServiceManager sharedManager] registerService:proto withImpl:impl];
}

+ (id)serviceForProtocol:(Protocol *)serviceProtocol
{
    return [[CSServiceManager sharedManager] serviceForProtocol:serviceProtocol];
}

+ (NSArray *)getAllServices
{
    return [[CSServiceManager sharedManager] getAllServices];
}

@end
