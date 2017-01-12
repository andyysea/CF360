//
//  NSString+YHAddition.m
//  Tools
//
//  Created by 杨应海 on 2015/9/6.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import "NSString+YHAddition.h"

@implementation NSString (YHAddition)

+ (BOOL)yh_isIncludeChineseInString:(NSString *)str {
    for (NSInteger i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return YES;
        }
    }
    return NO;
}


- (NSString *)yh_appendDocumentDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
  
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)yh_appendCacheDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)yh_appendTempDir {
    NSString *dir = NSTemporaryDirectory();
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

@end
