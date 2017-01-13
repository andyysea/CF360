//
//  CFHomeViewController.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFHomeViewController.h"

@interface CFHomeViewController ()

@end

@implementation CFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

#pragma mark - 视图已经出现
/**
    这里要开启控制器拖拽手势,以便在首页控制器滑动的时候能够打开左侧菜单控制器
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:YES];
}

#pragma mark - 视图已经消失
/**
    这里关闭控制器拖拽手势,避免由首页控制器push到的子控制器也能拖拽,累加之后造成混乱
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:NO];
}


#pragma mark - 设置界面
- (void)setupUI {
    NSString *str = @"hheheheh";
    NSLog(@"--> %@", str);
}



@end
