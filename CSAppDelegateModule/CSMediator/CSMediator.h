//
//  CSMediator.h
//  CSMediator_Example
//
//  Created by joy_yu on 2018/5/10.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSRouter.h"
#import "CSServiceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSMediator : NSObject

@end

@interface CSMediator(Router)

+ (void)registerRouterModule:(nonnull id<CSRouterModuleProtocol>)module;

+ (void)routerURL:(nonnull NSString *)urlString withParameter:(nullable NSDictionary *)parameter;

@end

@interface CSMediator(Service)

+ (void)registerService:(nonnull Protocol *)proto withImpl:(nonnull id)impl;

+ (nullable id)serviceForProtocol:(nonnull Protocol *)serviceProtocol;

+ (NSArray *)getAllServices;

@end

NS_ASSUME_NONNULL_END
