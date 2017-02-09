//
//  ProductCommendModel.m
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "ProductCommendModel.h"

@implementation ProductCommendModel


/**
 *  由于该请求返回的数据一共有五中类型的 模型数组 而且各个模型数组又有区别
 *  所以转模型的时候分开写,可以看到各个模型数组中用到哪些属性,同时便于以后修改
 */
- (NSArray *)productCommendModelArrayWithData:(NSDictionary *)dict {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *dataArray = dict[@"data"][@"recommendProduct"];
    if (dataArray.count) {

        for (NSInteger i = 0; i < dataArray.count; i++) {
            NSArray *contentArray = dataArray[i];
            
            switch (i) {
                case 0: // 信托
                {
                    if (contentArray.count) {
                        NSMutableArray *arrM = [NSMutableArray array];
                        for (NSDictionary *contentDict in contentArray) {
                            ProductCommendModel *model = [[ProductCommendModel alloc] init];
                            
                            model.auditStatus = dict[@"data"][@"auditStatus"];
                            model.title = contentDict[@"NAME"];
                            model.SALETYPE = [contentDict[@"SALETYPE"] isEqualToString:@"无"] ? @"" : contentDict[@"SALETYPE"];
                            model.SELLINGSTATUS = [contentDict[@"SELLINGSTATUS"] isEqualToString:@"无"] ? @"" : contentDict[@"SELLINGSTATUS"];
                            model.SELLINGSTATUS2 = [contentDict[@"RECOMMENDSTATUS"] isEqualToString:@"0"] ? @"" : @"推荐";
                            model.level = contentDict[@"CREDITLEVEL"];
                            model.leftName = @"认购金额";
                            model.leftValue = contentDict[@"AMOUNT"];
                            model.middleName = @"产品期限";
                            model.middleValue = contentDict[@"TIMELIMIT"];
                            model.rightName = @"返佣比例";
                            model.rightValue = contentDict[@"COMMISSION"];
                            model.isShow = contentDict[@"ISSHOW"];
                            model.percent = contentDict[@"RECRUITMENTPROCESS"];
                            model.pID = contentDict[@"ID"];
                            model.CATEGORY = contentDict[@"CATEGORY"];
                            
                            [arrM addObject:model];
                        }
                        [arrayM addObject:arrM];
                    }
                }
                    break;
                case 1:  // 资管
                {
                    if (contentArray.count) {
                        NSMutableArray *arrM = [NSMutableArray array];
                        for (NSDictionary *contentDict in contentArray) {
                            ProductCommendModel *model = [[ProductCommendModel alloc] init];
                            
                            model.auditStatus = dict[@"data"][@"auditStatus"];
                            model.title = contentDict[@"NAME"];
                            model.SALETYPE = [contentDict[@"SALETYPE"] isEqualToString:@"无"] ? @"" : contentDict[@"SALETYPE"];
                            model.SELLINGSTATUS = [contentDict[@"SELLINGSTATUS"] isEqualToString:@"无"] ? @"" : contentDict[@"SELLINGSTATUS"];
                            model.SELLINGSTATUS2 = [contentDict[@"RECOMMENDSTATUS"] isEqualToString:@"0"] ? @"" : @"推荐";
                            model.level = contentDict[@"CREDITLEVEL"];
                            model.leftName = @"认购金额";
                            model.leftValue = contentDict[@"AMOUNT"];
                            model.middleName = @"产品期限";
                            model.middleValue = contentDict[@"TIMELIMIT"];
                            model.rightName = @"返佣比例";
                            model.rightValue = contentDict[@"COMMISSION"];
                            model.isShow = contentDict[@"ISSHOW"];
                            model.percent = contentDict[@"RECRUITMENTPROCESS"];
                            model.pID = contentDict[@"ID"];
                            model.CATEGORY = contentDict[@"CATEGORY"];
                            
                            [arrM addObject:model];
                        }
                        [arrayM addObject:arrM];
                    }
                }
                    break;
                case 2: // 阳光私募
                {
                    if (contentArray.count) {
                        NSMutableArray *arrM = [NSMutableArray array];
                        for (NSDictionary *contentDict in contentArray) {
                            ProductCommendModel *model = [[ProductCommendModel alloc] init];
                            
                            model.auditStatus = dict[@"data"][@"auditStatus"];
                            model.title = contentDict[@"NAME"];
                            model.SALETYPE = [contentDict[@"SALETYPE"] isEqualToString:@"无"] ? @"" : contentDict[@"SALETYPE"];
                            model.SELLINGSTATUS = [contentDict[@"SELLINGSTATUS"] isEqualToString:@"无"] ? @"" : contentDict[@"SELLINGSTATUS"];
                            model.SELLINGSTATUS2 = [contentDict[@"RECOMMENDSTATUS"] isEqualToString:@"0"] ? @"" : @"推荐"; // 0/1 两种
//                            model.level = contentDict[@"CREDITLEVEL"];
                            model.leftName = @"认购金额";
                            model.leftValue = contentDict[@"AMOUNT"];
                            model.middleName = @"累计净值";
                            model.middleValue = [[NSString stringWithFormat:@"%@",contentDict[@"NAME5"]] isEqualToString:@"<null>"] ? @"--" : contentDict[@"NAME5"];
                            model.rightName = @"前端返佣";
                            model.rightValue = contentDict[@"COMMISSION"];
                            model.isShow = @"true";
                            model.percent = contentDict[@"RECRUITMENTPROCESS"];
                            model.pID = contentDict[@"ID"];
                            model.CATEGORY = contentDict[@"CATEGORY"];
                            
                            [arrM addObject:model];
                        }
                        [arrayM addObject:arrM];
                    }
                }
                    break;
                case 3: // 私募股权
                {
                    if (contentArray.count) {
                        NSMutableArray *arrM = [NSMutableArray array];
                        for (NSDictionary *contentDict in contentArray) {
                            ProductCommendModel *model = [[ProductCommendModel alloc] init];
                            
                            model.auditStatus = dict[@"data"][@"auditStatus"];
                            model.title = contentDict[@"NAME"];
                            model.SALETYPE = [contentDict[@"SALETYPE"] isEqualToString:@"无"] ? @"" : contentDict[@"SALETYPE"];
                            model.SELLINGSTATUS = [contentDict[@"SELLINGSTATUS"] isEqualToString:@"无"] ? @"" : contentDict[@"SELLINGSTATUS"];
                            model.SELLINGSTATUS2 = [contentDict[@"RECOMMENDSTATUS"] isEqualToString:@"0"] ? @"" : @"推荐"; // 0/1 两种
//                            model.level = contentDict[@"CREDITLEVEL"];
                            model.leftName = @"认购金额";
                            model.leftValue = contentDict[@"AMOUNT"];
                            model.middleName = @"投资期限";
                            model.middleValue = contentDict[@"NAME5"];
                            model.rightName = @"前端返佣";
                            model.rightValue = contentDict[@"COMMISSION"];
                            model.isShow = @"true";
                            model.percent = contentDict[@"RECRUITMENTPROCESS"];
                            model.pID = contentDict[@"ID"];
                            model.CATEGORY = contentDict[@"CATEGORY"];
                            
                            [arrM addObject:model];
                        }
                        [arrayM addObject:arrM];
                    }
                }
                    break;
                case 4:  //  保险 --> 保险不显示进度条
                {
                    if (contentArray.count) {
                        NSMutableArray *arrM = [NSMutableArray array];
                        for (NSDictionary *contentDict in contentArray) {
                            ProductCommendModel *model = [[ProductCommendModel alloc] init];
                            
                            model.auditStatus = dict[@"data"][@"auditStatus"];
                            model.title = contentDict[@"NAME"];
//                            model.SALETYPE = [contentDict[@"SALETYPE"] isEqualToString:@"无"] ? @"" : contentDict[@"SALETYPE"];
                            model.SELLINGSTATUS = [contentDict[@"SELLINGSTATUS"] isEqualToString:@"无"] ? @"" : contentDict[@"SELLINGSTATUS"];
                            model.SELLINGSTATUS2 = [contentDict[@"RECOMMENDSTATUS"] isEqualToString:@"0"] ? @"" : @"推荐"; // 0/1 两种
//                            model.level = contentDict[@"CREDITLEVEL"];
                            model.leftName = @"保险公司";
                            model.leftValue = contentDict[@"COMPANYNAME"];
                            model.middleName = @"保险期间";
                            model.middleValue = contentDict[@"TIMELIMIT"];
                            model.rightName = @"返佣比例";
                            model.rightValue = contentDict[@"COMMISSION"];
                            model.isShow = @"false";
                            model.percent = contentDict[@"RECRUITMENTPROCESS"];
                            model.pID = contentDict[@"ID"];
                            model.CATEGORY = contentDict[@"CATEGORY"];
                            
                            [arrM addObject:model];
                        }
                        [arrayM addObject:arrM];
                    }
                }
                    break;
 
                default:
                    break;
            }
        }
        
    }
    
    return arrayM.copy;
}


@end
