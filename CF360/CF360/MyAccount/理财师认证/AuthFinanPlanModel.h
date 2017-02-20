//
//  AuthFinanPlanModel.h
//  CF360
//
//  Created by junde on 2017/2/16.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthFinanPlanModel : NSObject

@property(nonatomic,copy)NSString *realName;       // 真实姓名
@property(nonatomic,copy)NSString *regionaProvince;// 省份
@property(nonatomic,copy)NSString *regionaCity;    // 城市
@property(nonatomic,copy)NSString *companyName;    // 公司名称
@property(nonatomic,copy)NSString *email;          // 邮箱

@property(nonatomic,copy)NSString *busineseCardUrl;// 有效证件urlstr

/** 返回一个转好的模型 */
+ (void)loadAuthFinanPlanerRequestCompletionHandler:(void(^)(AuthFinanPlanModel *model))complete;

@end
