//
//  AuthFinanPlanViewController.h
//  CF360
//
//  Created by junde on 2017/2/15.
//  Copyright © 2017年 junde. All rights reserved.
//

/**
 理财师认证控制器
 */

#import "CFBaseViewController.h"

@interface AuthFinanPlanViewController : CFBaseViewController

/** 认证者的电话--> 刚注册时的电话 */
@property (nonatomic, copy) NSString *phoneStr;

/** 是否显示导航栏右侧的跳过按钮 */
@property (nonatomic, assign) BOOL isRightItemShow;

@end
