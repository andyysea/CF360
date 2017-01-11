//
//  UIButton+YHAddition.h
//  Tools
//
//  Created by 杨应海 on 2015/10/11.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YHAddition)

/**
 创建文本按钮
 
 @param title            标题文字
 @param fontSize         字体大小
 @param normalColor      默认颜色
 @param highlightedColor 高亮颜色
 
 @return UIButton
 */
+ (instancetype)yh_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor;


/**
 创建文本按钮
 
 @param title               标题文字
 @param fontSize            字体大小
 @param normalColor         默认颜色
 @param highlightedColor    高亮颜色
 @param backgroundImageName 背景图像名称
 
 @return UIButton
 */
+ (instancetype)yh_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName;


/**
 创建图像按钮
 
 @param imageName           图像名称
 @param backgroundImageName 背景图像名称
 
 @return UIButton
 */
+ (instancetype)yh_imageButton:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName;

@end
