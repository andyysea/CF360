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
            // 186 135 89
    return [UIColor yh_colorWithRed:186 green:135 blue:89];
}

/** UITableView 系统默认的背景颜色 */
+ (instancetype)yh_colorWithTableViewDefault {
    
    return [UIColor yh_colorWithRed:239 green:239 blue:244];
}


/** 浅灰色 230 230 230 */
+ (instancetype)yh_colorLightGrayCommon {
    return [UIColor yh_colorWithRed:230 green:230 blue:230];
}

/** 红色 218 85 90*/
+ (instancetype)yh_colorSimpleRedCommon {
    return [UIColor yh_colorWithRed:218 green:85 blue:90];
}

/** 淡蓝色 141  193 254 */
+ (instancetype)yh_colorSimpleBlueCommon {
    return [UIColor yh_colorWithRed:141 green:193 blue:254];
}





@end
