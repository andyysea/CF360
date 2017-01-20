//
//  UIColor+Common.m
//  CF360
//
//  Created by junde on 2017/1/12.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)


/** 与导航栏颜色相近的黄色 */
+ (instancetype)yh_colorNavYellowCommon {
            // 184 138 90
//    return [UIColor yh_colorWithRed:184 green:138 blue:90];
    return [UIColor colorWithRed:0.73 green:0.53 blue:0.33 alpha:1.0];
}

/** UITableView 系统默认的背景颜色 */
+ (instancetype)yh_ColorWithTableViewDefault {
    
    return [UIColor yh_colorWithRed:239 green:239 blue:244];
}




@end
