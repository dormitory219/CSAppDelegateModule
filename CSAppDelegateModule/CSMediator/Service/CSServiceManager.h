//
//  CSModuleManager.h
//  CSModuleManager
//
//  Created by joy_yu on 2018/1/27.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSServiceModuleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CSService <NSObject>

@end

@interface CSServiceManager : NSObject

+ (instancetype)sharedManager;

@end


@interface CSServiceManager(Service)

- (void)registerService:(Protocol *)proto withImpl:(id)impl;

- (__nullable id)serviceForProtocol:(Protocol *)serviceProtocol;

- (NSArray *)getAllServices;

@end

NS_ASSUME_NONNULL_END
