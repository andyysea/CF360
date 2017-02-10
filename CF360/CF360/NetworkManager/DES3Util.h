//
//  DES3Util.h
//  CF360
//
//  Created by junde on 2017/1/22.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject


/** 加密方法 */
+ (NSString*)encrypt:(NSString*)plainText;

/** 解密方法 */
+ (NSString*)decrypt:(NSString*)encryptText;

@end
