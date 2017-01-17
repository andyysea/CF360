//
//  AppDelegate.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworkActivityIndicatorManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置网络指示器,并监控网络状态
    [self setNetworking];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CFHomeViewController *homeVC = [[CFHomeViewController alloc] init];
    self.homeNav = [[CFNavgationController alloc] initWithRootViewController:homeVC];
    CFLeftViewController *leftVC = [[CFLeftViewController alloc] init];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftVC];
    self.drawerController = [[YHLeftDrawerController alloc] initWithLeftView:leftNav andMainView:self.homeNav];
    _window.rootViewController = self.drawerController;
    [_window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 设置网络指示器并监控网络状态
- (void)setNetworking {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 上面的方法调用之后,只需要在各个需要的控制器中(viewDidLoad方法中)添加添加观察者即可,代码如下
    /**
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networking:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
     
     - (void)networking:(NSNotification *)n {
     NSLog(@"---> %@",n.userInfo);
     }
     */
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
