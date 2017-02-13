//
//  UserAccount.m
//  CF360
//
//  Created by junde on 2017/2/10.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

/**
 初始化得到用户唯一账户 单例
 */
+ (instancetype)shareManager {
    static UserAccount *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


@end
