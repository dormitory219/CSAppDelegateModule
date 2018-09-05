//
//  CSRouter.h
//  CSMediator_Example
//
//  Created by joy_yu on 2018/5/10.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSRouterModuleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSRouter : NSObject

+ (nonnull instancetype)router;

- (void)registerRouterModule:(nonnull id<CSRouterModuleProtocol>)module;

- (BOOL)routerURL:(nonnull NSString *)url withParameter:(nullable NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
