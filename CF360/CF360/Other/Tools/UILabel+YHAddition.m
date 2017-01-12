//
//  UILabel+YHAddition.m
//  Tools
//
//  Created by 杨应海 on 2015/11/11.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import "UILabel+YHAddition.h"

@implementation UILabel (YHAddition)

+ (instancetype)yh_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)color {
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    return label;
}


@end
