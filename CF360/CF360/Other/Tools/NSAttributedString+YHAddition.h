//
//  NSAttributedString+YHAddition.h
//  Tools
//
//  Created by 杨应海 on 2015/12/4.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (YHAddition)

/**
 使用图像和文本生成上下排列的属性文本

 @param image      图像
 @param imageWH    图像宽高
 @param title      标题文字
 @param fontSize   标题字体大小
 @param titleColor 标题颜色
 @param spacing    图像和标题间距

 @return 属性文本
 */
+ (instancetype)yh_imageTextWithImage:(UIImage *)image
                              imageWH:(CGFloat)imageWH
                                title:(NSString *)title
                             fontSize:(CGFloat)fontSize
                           titleColor:(UIColor *)titleColor
                              spacing:(CGFloat)spacing;



@end
