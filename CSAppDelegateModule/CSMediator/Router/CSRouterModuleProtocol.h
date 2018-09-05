//
//  RouterModuleProtocol.h
//  CSMediator
//
//  Created by joy_yu on 2018/5/10.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#ifndef RouterModuleProtocol_h
#define RouterModuleProtocol_h


@protocol CSRouterModuleProtocol <NSObject>

@optional
-(BOOL)canRouteModule:(nonnull NSString *)URL;

@required
- (nullable id)routerURL:(nonnull NSString *)URL params:(nullable NSDictionary *)params;

@end

#endif /* RouterModuleProtocol_h */
