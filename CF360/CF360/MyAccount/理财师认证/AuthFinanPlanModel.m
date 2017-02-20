//
//  AuthFinanPlanModel.m
//  CF360
//
//  Created by junde on 2017/2/16.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "AuthFinanPlanModel.h"

@implementation AuthFinanPlanModel

/** 返回一个转好的模型 */
+ (void)loadAuthFinanPlanerRequestCompletionHandler:(void(^)(AuthFinanPlanModel *model))complete {
    [ProgressHUD show:@"努力加载中,请稍后!" Interaction:NO];
    [[MKNetWorkManager shareManager] loadAuthFinanPlanerRequestCompletionHandler:^(id responseData, NSError *error) {
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        
        NSLog(@"--> %@\n --> %@", responseData, dict);
        
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            if ([[dict[@"data"] allKeys] containsObject:@"busineseCardUrl"] &&
                [[dict[@"data"] allKeys] containsObject:@"user"] &&
                [[dict[@"data"][@"user"] allKeys] containsObject:@"realName"]) {
                
                AuthFinanPlanModel *model = [AuthFinanPlanModel yy_modelWithDictionary:dict[@"data"][@"user"]];
                model.busineseCardUrl = dict[@"data"][@"busineseCardUrl"];
                
                if (complete) {
                    complete(model);
                }
            }
            
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        } else {
            [ProgressHUD dismiss];
        }
    }];

}



@end
