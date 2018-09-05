//
//  CSAppDelegateServiceManager.m
//  CSAppDelegateModule
//
//  Created by 余强 on 2018/5/7.
//  Copyright © 2018年 IntSig Information Co., Ltd. All rights reserved.
//

#import "CSAppDelegateServiceManager.h"
#import "CSAppDelegateProxyViewController.h"
#import "CSAppDelegatePrivateServiceProtocol.h"
#import "CSAppDelegateServiceManagerProtocol.h"

//#import "CSAppDelegateApperanceService.h"
//#import "CSAppDelegateShortcutOperationService.h"

#import "CSAppServiceDataMode.h"
#import "CSMediator.h"

static const NSInteger commonPriority =  100000;

@interface CSAppDelegateServiceManager()

@property (nonatomic,strong) NSMutableArray <id<CSAppDelegateServiceProtocol>>*serviceArray;
@property (nonatomic,strong) NSMutableArray <NSString *>*serviceNameArray;
@property (nonatomic,strong) dispatch_queue_t serviceQueue;

@end

@implementation CSAppDelegateServiceManager

@synthesize window = _window;

+ (instancetype)shareManager
{
    static CSAppDelegateServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
      [CSMediator registerService:@protocol(CSAppDelegateServiceManagerProtocol) withImpl:self];
        
        _serviceQueue = dispatch_queue_create("com.camscannner.appDelegateServiceQueue",
                                               DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

/*
 CSAppDelegateModule模块内的所有services理论上可进行热插播，除了一些service 内部有exception
 处理逻辑导致热插拔会crash，如CSAppDelegateLogService中logAgent，CSAppDelegateIntializeService中dataCenter
 
 模块内service分为四大类：
 1.mainflowService:
 用来控制启动逻辑流程的service，该service可梳理启动时处理的所有逻辑；
 2.uiService:
 一些偏ui方面的service，比如强制更新，开屏，密码保护
 3.pluginService:
 类似插件功能的service,比如crash收集，实时埋点，上传applist，控制全局ui样式
 4.openAppService:
 主要是启动app，或者打开app的一些方式service,比如openAPI,上传pdf,3DTouch进入，widget进入，spotlight进入
 
 热插拔时注意在debug环境下CSMediator的异常处理机制，先修改再去热插拔

 */
- (void)registerAllService
{
    NSString *path = nil;
    NSArray *services = nil;
    path = [[NSBundle mainBundle] pathForResource:@"mainFlowServicesPlist" ofType:@"plist"];
    services = [NSArray arrayWithContentsOfFile:path];
    [self addServices:services];
    
    path = [[NSBundle mainBundle] pathForResource:@"pluginServicesPlist" ofType:@"plist"];
    services = [NSArray arrayWithContentsOfFile:path];
    [self addServices:services];

    path = [[NSBundle mainBundle] pathForResource:@"uiServicesPlist" ofType:@"plist"];
    services = [NSArray arrayWithContentsOfFile:path];
    [self addServices:services];

    path = [[NSBundle mainBundle] pathForResource:@"openAppServicesPlist" ofType:@"plist"];
    services = [NSArray arrayWithContentsOfFile:path];
    [self addServices:services];
    
    /*
     测试环境对service热插拨的预处理:
     在mainflowService注入情况下，有些service重度依赖（内部有exception机制）必须注入:
     如CSAppDelegateMainFlowService,CSAppDelegateViewControllerService，CSAppDelegateLogService
     */
   #ifdef DEBUG
//    if ([self.serviceNameArray containsObject:NSStringFromClass([CSAppDelegateMainFlowService class])])
//    {
//        NSArray *dependencyServices = @[
//                                        NSStringFromClass([CSAppDelegateIntializeService class]),
//                                        NSStringFromClass([CSAppDelegateViewControllerService class]),
//                                        NSStringFromClass([CSAppDelegateLogService class])
//                                        ];
//        for (NSString *dependencyService in dependencyServices)
//        {
//            Class serviceClass = NSClassFromString(dependencyService);
//            if (![self.serviceNameArray containsObject:dependencyService])
//            {
//                NSLog(@"CSAppDelegateModule: must support service<<%@>> to prevent crash,so manual add this service",dependencyService);
//                [self.serviceArray addObject:[[serviceClass alloc] init]];
//                [self.serviceNameArray addObject:NSStringFromClass([CSAppDelegateIntializeService class])];
//            }
//        }
//    }
   #endif
    NSLog(@"CSAppDelegateModule: support service list:%@",[self.serviceNameArray componentsJoinedByString:@","]);
    NSLog(@"CSAppDelegateModule:all services are ready, so let launch app !");
}

- (void)addServices:(NSArray *)serviceNames
{
    if (!serviceNames.count) {
        return;
    }
    dispatch_barrier_sync(_serviceQueue, ^{
        if (!serviceNames.count)
        {
            return;
        }
        for (NSString *serviceName in serviceNames)
        {
            if ([self.serviceNameArray containsObject:serviceName])
            {
                NSLog(@"service <<%@>> has register,next",serviceName);
                continue;
            }
            Class serviceClass = NSClassFromString(serviceName);
            id service = [[serviceClass alloc] init];
            if (service) {
                [self.serviceArray addObject:service];
                [self.serviceNameArray addObject:serviceName];
            }
        }
    });
}

- (void)removeServices:(NSArray *)serviceNames
{
    dispatch_barrier_async(_serviceQueue, ^{
        if (!serviceNames.count)
        {
            return;
        }
        for (NSString *serviceName in serviceNames)
        {
            if (![self.serviceNameArray containsObject:serviceName])
            {
                NSLog(@"service <<%@>> not register,next",serviceName);
                continue;
            }
            Class serviceClass = NSClassFromString(serviceName);
            id service = [[serviceClass alloc] init];
            [self.serviceArray removeObject:service];
            [self.serviceNameArray removeObject:serviceName];
        }
    });
}


/*
 对多种业务叠加的service进行优先级的处理，该优先级可根据不同的appDelegate生命周期业务进行定制，优先级和service在数组中位置进行对应
 如：performActionForShortcutItem
    CSAppDelegateDataBaseMigrationService -> CSAppDelegateShortcutOperationService
 */
- (void)setSortServices:(NSArray *)sortServices
{
    _sortServices = sortServices;
    if (!sortServices.count)
    {
        return;
    }
    
    for (id<CSAppDelegateServiceProtocol> service in self.serviceArray)
    {
        service.priority = commonPriority;
    }
    for (Class service in sortServices)
    {
        id<CSAppDelegateServiceProtocol> appService = [self serviceForClass:service];
        appService.priority = [sortServices indexOfObject:service];
    }
   
    [self.serviceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        id<CSAppDelegateServiceProtocol> appService1 = obj1;
        id<CSAppDelegateServiceProtocol> appService2 = obj2;
        return appService1.priority > appService2.priority;

    }];
}

/*
 核心启动流程处理
 该核心业务处理逻辑在CSAppDelegateMainFlowService,基于热插拔service，如果该service没在services列表中，则默认用CSAppDelegateProxyViewController来处理app的视图框架。
 注：
启动入口逻辑只允许CSAppDelegateMainFlowService，CSAppDelegateIntializeService两个服务来接管处理逻辑
 CSAppDelegateIntializeService 初始化流程，
 CSAppDelegateMainFlowService 处理启动各种service依赖流程
 
 检测CSAppDelegateMainFlowService是否注入，如果无，则不进行任何service服务，
 另：在debug下CSAppDelegateMainFlowService未注入，默认使用CSAppDelegateProxyViewController接管CSAppDelegateMainFlowService的流程服务
 */
- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo
{
    for (id service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(application:didReceiveRemoteNotification:)])
        {
            [service application:application didReceiveRemoteNotification:userInfo];
        }
    }
}
#pragma clang diagnostic pop

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken
{
    for (id service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)])
        {
            [service application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }
}

/*
 通过3dTouch open app
 该核心业务处理逻辑在CSAppDelegateShortcutOperationService中， 但对于数据库迁移等操作，这些业务处理需要被阻断，
 业务优先级：CSAppDelegateDataBaseMigrationService  -> CSAppDelegateShortcutOperationService
 */
- (void)application:(UIApplication *) application performActionForShortcutItem:(UIApplicationShortcutItem *) shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler
{
    CSAppServiceDataMode *open = nil;
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(application:performActionForShortcutItem:completionHandler:)])
        {
            open =  [service application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
            if (open.shouldInterrupt)
            {
                break;
            }
        }
    }
}

/*
 通过openurl open app
 该核心业务处理逻辑在CSAppDelegateOpenAPIService,CSAppDelegateOpenImageService,CSAppDelegateOpenPDFService,CSAppDelegateExtensionService等中， 但对于数据库迁移等操作，这些业务处理需要被阻断，
 业务优先级：CSAppDelegateDataBaseMigrationService  -> CSAppDelegateSNSService -> CSAppDelegateExtensionService -> CSAppDelegateOpenAPIService
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    CSAppServiceDataMode *open = nil;
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)])
        {
             open =  [service application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
             if (open.shouldInterrupt)
            {
                break;
            }
        }
    }
     return open.boolValue;
}

/*
 通过spotelight open app
 该核心业务处理逻辑在CSAppDelegateSpotlightService中， 但对于数据库迁移操作，该业务处理需要被阻断，
 业务优先级：CSAppDelegateDataBaseMigrationService  -> CSAppDelegateSpotlightService
 */
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * restorableObjects))restorationHandler
{
    CSAppServiceDataMode *open = nil;
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(application:continueUserActivity:restorationHandler:)])
        {
            open =  [service application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
            if (open.shouldInterrupt)
            {
                break;
            }
        }
    }
    return open.boolValue;
}

- (void)applicationDidBecomeActive:(UIApplication *) application
{
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(applicationDidBecomeActive:)])
        {
            [service applicationDidBecomeActive:application];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *) application
{
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(applicationWillResignActive:)])
        {
            [service applicationWillResignActive:application];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    for (id service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(applicationWillTerminate:)])
        {
            [service applicationWillTerminate:application];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(applicationDidEnterBackground:)])
        {
            BOOL interrupt =  [service applicationDidEnterBackground:application];
            if (interrupt)
            {
                break;
            }
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    for (id<CSAppDelegateServiceProtocol>service in self.serviceArray)
    {
        if ([service respondsToSelector:@selector(applicationWillEnterForeground:)])
        {
           BOOL interrupt =  [service applicationWillEnterForeground:application];
            if (interrupt)
            {
                break;
            }
        }
    }
}
             
- (id)serviceForClass:(Class)serviceClass
{
    id service;
    for (id appService in self.serviceArray)
    {
        NSString *className = NSStringFromClass([appService class]);
        if ([className isEqualToString:NSStringFromClass(serviceClass)])
        {
            service = appService;
            break;
        }
    }
    return service;
}

- (NSMutableArray <id<CSAppDelegateServiceProtocol>>*)serviceArray
{
    if (!_serviceArray)
    {
        _serviceArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _serviceArray;
}

- (NSMutableArray<NSString*> *)serviceNameArray
{
    if (!_serviceNameArray)
    {
       _serviceNameArray  = [NSMutableArray arrayWithCapacity:2];
    }
    return _serviceNameArray;
}

@end
