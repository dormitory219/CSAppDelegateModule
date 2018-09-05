//
//  CSModuleManager.m
//  CSModuleManager
//
//  Created by joy_yu on 2018/1/27.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import "CSServiceManager.h"

static NSMutableDictionary <NSString *, id <CSService>> *serviceImplNameMap = nil;

@implementation CSServiceManager

+ (instancetype)sharedManager
{
    static CSServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - service

- (void)registerService:(Protocol *)proto withImpl:(id)impl
{
    NSParameterAssert(proto != nil);
    NSParameterAssert(impl != nil);
    if (![impl conformsToProtocol:proto])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 服务不符合 %@ 协议", NSStringFromClass([impl class]), NSStringFromProtocol(proto)] userInfo:nil];
    }
    
    if ([serviceImplNameMap objectForKey:NSStringFromProtocol(proto)])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 协议已经注册", NSStringFromProtocol(proto)] userInfo:nil];
    }
    
    @synchronized(serviceImplNameMap)
    {
        if (serviceImplNameMap == nil)
        {
            serviceImplNameMap = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        NSString *protoName = NSStringFromProtocol(proto);
        if ([serviceImplNameMap objectForKey:protoName] == nil)
        {
            [serviceImplNameMap setObject:impl forKey:protoName];
        }
    }
}

- (id)serviceForProtocol:(Protocol *)serviceProtocol
{
    return [self findServiceByName:NSStringFromProtocol(serviceProtocol)];
}

- (NSArray *)getAllServices
{
    return [serviceImplNameMap allValues];
}

- (id)findServiceByName:(NSString *)name
{
    id service = [serviceImplNameMap objectForKey:name];
    if (service == nil)
    {
        NSString *exceptionDesc = [NSString stringWithFormat:@"%@ 服务未取到相应实现类", name];
      #ifdef DEBUG
        NSLog(exceptionDesc);
        //@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:exceptionDesc userInfo:nil];
      #else
        ISError(exceptionDesc);
      #endif
    }
    return service;
}

@end
