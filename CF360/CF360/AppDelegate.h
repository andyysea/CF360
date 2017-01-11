//
//  AppDelegate.h
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHLeftDrawerController.h"
#import "CFNavgationController.h"
#import "CFLeftViewController.h"
#import "CFHomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) YHLeftDrawerController *drawerController; //抽屉控制器

@property (nonatomic, strong) CFNavgationController *homeNav; //Home的导航控制器

@end

