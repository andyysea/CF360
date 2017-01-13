//
//  CFHomeViewController.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFHomeViewController.h"
#import "MessageViewController.h" // 导航栏消息控制器

/**
    定义枚举类型,来设置添加按钮的 tag
 */
typedef NS_ENUM(NSInteger, MyButtonTag) {
    MyButtonTagOfNavLeft,
    MyButtonTagOfNavRight
};

@interface CFHomeViewController ()

@end

@implementation CFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavgationBar];
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

#pragma mark - 导航栏上 左边/右边 按钮点击方法
- (void)navButtonClick:(UIButton *)button {
    
    
    switch (button.tag) {
        case MyButtonTagOfNavLeft:
        {
            // 打开/关闭 左侧菜单控制器
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.drawerController.closed ? [delegate.drawerController openLeftView] : [delegate.drawerController closeLeftView];
        }
            break;
            
        case MyButtonTagOfNavRight:
        {
            // 跳转消息控制器
            MessageViewController *messageVC = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 设置导航栏
- (void)setupNavgationBar {
    
    // 1>添加导航栏中 能打开左侧菜单控制器的按钮
    UIButton *leftNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftNavButton.tag = MyButtonTagOfNavLeft;
    [leftNavButton setImage:[UIImage imageNamed:@"icon-菜单"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2> 添加导航栏中间的图标视图 titleView
    UIImageView *navTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    navTitleView.image = [UIImage imageNamed:@"img-LOGO"];
    navTitleView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navTitleView;
    
    // 3> 添加导航栏中右侧的消息按钮
    UIButton *rightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    rightNavButton.tag = MyButtonTagOfNavRight;
    [rightNavButton setImage:[UIImage imageNamed:@"icon-信息提示框"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置界面
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
}



@end
