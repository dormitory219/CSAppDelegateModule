//
//  CSAppDelegateServiceManager.h
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSAppDelegateServiceHeader.h"
#import "CSAppDelegateServiceManagerProtocol.h"

@interface CSAppDelegateServiceManager : NSObject<UIApplicationDelegate,CSAppDelegateServiceManagerProtocol>

@property (nonatomic,strong) NSArray *sortServices;

+ (instancetype)shareManager;

- (void)registerAllService;

@end
