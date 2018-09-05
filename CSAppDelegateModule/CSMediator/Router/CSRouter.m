//
//  CSRouter.m
//  CSMediator_Example
//
//  Created by joy_yu on 2018/5/10.
//  Copyright © 2018年 joy_yu. All rights reserved.
//

#import "CSRouter.h"
#import "CSRouterModuleProtocol.h"

static NSMutableDictionary <NSString *, id<CSRouterModuleProtocol>> *routerModuleMap = nil;

@implementation CSRouter

+ (nonnull instancetype)router
{
    static CSRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

- (void)registerRouterModule:(id<CSRouterModuleProtocol>)module
{
    NSParameterAssert(module != nil);
    if (![module conformsToProtocol:@protocol(CSRouterModuleProtocol)])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ 服务不符合 %@ 协议", NSStringFromClass([module class]), NSStringFromProtocol(@protocol(CSRouterModuleProtocol))] userInfo:nil];
    }
    
    @synchronized(routerModuleMap)
    {
        if (routerModuleMap == nil)
        {
            routerModuleMap = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        NSString *connectorClsStr = NSStringFromClass([module class]);
        if ([routerModuleMap objectForKey:connectorClsStr] == nil)
        {
            [routerModuleMap setObject:module forKey:connectorClsStr];
        }
    }
}

- (BOOL)routerURL:(nonnull NSString *)urlString withParameter:(nullable NSDictionary *)parameter
{
    if(!routerModuleMap || routerModuleMap.count <= 0)
    {
        return NO;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *allParams = [self userParametersWithURL:url andParameters:parameter];
    for (id <CSRouterModuleProtocol> module in routerModuleMap.allValues)
    {
        if (![module conformsToProtocol:@protocol(CSRouterModuleProtocol)])
        {
            continue;
        }
        if (![module respondsToSelector:@selector(routerURL:params:)])
        {
            continue;
        }
        if ([module canRouteModule:urlString])
        {
            [module routerURL:urlString params:allParams];
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)userParametersWithURL:(nonnull NSURL *)URL andParameters:(nullable NSDictionary *)params{
    NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *userParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2)
        {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [self URLDecodedString:[kv objectAtIndex:1]];
            [userParams setObject:value forKey:key];
        }
    }
    [userParams addEntriesFromDictionary:params];
    return [NSDictionary dictionaryWithDictionary:userParams];
}

- (nonnull NSString *)URLDecodedString:(nonnull NSString *)urlString
{
    NSString *result = urlString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                   (__bridge CFStringRef)urlString,
                                                                                                   CFSTR(""),
                                                                                                   kCFStringEncodingUTF8);
#else
    result = [urlString stringByRemovingPercentEncoding];
#endif
    return result;
}

@end
