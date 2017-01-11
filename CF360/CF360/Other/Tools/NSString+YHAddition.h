//
//  NSString+YHAddition.h
//  Tools
//
//  Created by 杨应海 on 2015/9/6.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YHAddition)

/**
 判断一个字符串中是否包含汉子

 @param str 需要判断的字符串

 @return 返回判断结果
 */
+ (BOOL)yh_isIncludeChineseInString:(NSString *)str;


/**
 给当前文件追加文档路径
 
 @return 返回文件的文档路劲
 */
- (NSString *)yh_appendDocumentDir;


/**
 给当前文件追加缓存路径

 @return 返回文件的缓存路劲
 */
- (NSString *)yh_appendCacheDir;


/**
 给当前文件追加临时路径

 @return 返回文件的临时路劲
 */
- (NSString *)yh_appendTempDir;



@end
