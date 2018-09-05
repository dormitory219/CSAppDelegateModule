//
//  CSAppDelegateModulePublicProtocol.h
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/10.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#ifndef CSAppDelegateModulePublicProtocol_h
#define CSAppDelegateModulePublicProtocol_h

#import "CSAppDelegateServiceHeader.h"
#import "CSAppDelegatePrivateServiceProtocol.h"
#import "CSAppDelegateServiceManagerProtocol.h"

@protocol CSAppDelegateModuleProtocol <CSAppDelegateServiceManagerProtocol,CSAppDelegatePrivateServiceProtocol>

@end


#endif /* CSAppDelegateModulePublicProtocol_h */
