//
//  NSObject+YHRunTime.h
//  Tools
//
//  Created by 杨应海 on 2015/5/4.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YHRunTime)

/**
 返回当前类的属性数组
 
 @return 属性数组
 */
+ (NSArray *)yh_propertiesList;


/**
 返回当前类的成员变量数组
 
 @return 成员变量数组
 */
+ (NSArray *)yh_ivarsList;


/**
 使用字典数组创建当前类对象的数组

 @param array  字典数组

 @return 当前类对象的数组
 */
+ (NSArray *)yh_objectsWithArray:(NSArray *)array;



@end
