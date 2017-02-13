//
//  CFLeftViewController.h
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserAccount;

@interface CFLeftViewController : UIViewController

/**
    用户账户信息 -> 在这里是为了打开左侧抽屉控制器的时候是否显示左侧的信息
 */
@property (nonatomic, strong) UserAccount *userAccount;

/**
    菜单控制器的表格视图
 */
@property (nonatomic, strong) UITableView *tableView;

@end
