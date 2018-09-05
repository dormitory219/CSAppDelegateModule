//
//  CSAppDelegateModuleProxy.h
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/8/14.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSAppDelegateModuleProxy : NSObject

+ (instancetype)ProxyforwardingTargetForSelector:(SEL)aSelector;

@end
