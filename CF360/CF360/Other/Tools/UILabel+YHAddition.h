//
//  UILabel+YHAddition.h
//  Tools
//
//  Created by 杨应海 on 2015/11/11.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YHAddition)

/// 创建文本标签
///
/// @param text     文本
/// @param fontSize 字体大小
/// @param color    颜色
///
/// @return UILabel
+ (instancetype)yh_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)color;

@end
