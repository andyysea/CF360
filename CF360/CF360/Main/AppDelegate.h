//
//  AppDelegate.h
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHLeftDrawerController.h" // 抽屉控制器
#import "CFNavgationController.h"  // 导航控制器
#import "CFLeftViewController.h"   // 打开抽屉的左侧菜单控制器
#import "CFHomeViewController.h"   // 正中间的控制器

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) YHLeftDrawerController *drawerController; //抽屉控制器

@property (nonatomic, strong) CFNavgationController *homeNav; //Home的导航控制器

@end

