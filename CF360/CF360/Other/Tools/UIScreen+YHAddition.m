//
//  UIScreen+YHAddition.m
//  Tools
//
//  Created by 杨应海 on 2015/11/11.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import "UIScreen+YHAddition.h"

@implementation UIScreen (YHAddition)

+ (CGFloat)yh_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)yh_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)yh_scale {
    return [UIScreen mainScreen].scale;
}


@end
