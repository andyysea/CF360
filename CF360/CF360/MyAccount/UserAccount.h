//
//  UserAccount.h
//  CF360
//
//  Created by junde on 2017/2/10.
//  Copyright © 2017年 junde. All rights reserved.
//


/**
 设计一个用户单例
 --> 可以作为模型使用
 --> 可以封装 登陆/退出 时候的方法
 */

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;//机构或个人
@property (nonatomic, copy) NSString *status;// ->是否认证
@property (nonatomic, copy) NSString *statusBX;//保险是否认证
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString *isisLogin;
@property (nonatomic, assign) double allMoney;
@property (nonatomic, copy) NSString *userId;//userid
@property (nonatomic, copy) NSString *password;//password

@property (nonatomic, copy) NSString *expenseAll;//总额
@property (nonatomic, copy) NSString *expenseLeft;// ->佣金余额
@property (nonatomic, copy) NSString *FrozenRMB;//冻结
@property (nonatomic, copy) NSString *totalDeal;//累计成交

/** 
 初始化得到用户唯一账户 单例
 */
+ (instancetype)shareManager;

@end
