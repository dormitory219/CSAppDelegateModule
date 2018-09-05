//
//  CSAppDelegateModuleProxy.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/8/14.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateModuleProxy.h"
#import "CSAppDelegateProxyViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface CSAppDelegateModuleProxy()

@property (nonatomic,assign) SEL sel;

@end

@implementation CSAppDelegateModuleProxy

/*
 防crash机制，主要防止CSAppDelegateModule未实现内部imp service或serviceManager的实现方法:
 测试方法1:
 注释CSAppDelegateModule 中 presentMainViewWithCompletion,通过widget进入app,走crash流程
 
 测试方法2:
 注释isAddingPage，setIsAddingPage:(BOOL)isAddingPage方法，在主界面添加文档,走crash流程
 */
+ (instancetype)ProxyforwardingTargetForSelector:(SEL)aSelector
{
    CSAppDelegateModuleProxy *instance  = [[self alloc] init];
    IMP imp = class_getMethodImplementation([self class], @selector(forwardingMethod));
    instance.sel = aSelector;
    class_addMethod([self class], aSelector, imp, "v@:");
    return instance;
}

- (void)forwardingMethod
{
    NSLog(@"CSAppDelegateModule: CSAppDelegateModuleProxy handle << %@ >>crash,but do nothing",NSStringFromSelector(self.sel));
}

@end
