//
//  MKNetWorkManager.h
//  CF360
//
//  Created by junde on 2017/2/6.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKNetWorkManager : NSObject

#pragma mark - 单例设计,用于初始化网络工具类
+ (instancetype)shareManager;

#pragma mark - 1.1 首页轮播图网络请求
- (void)loadLoopImagesCompletion:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 1.2 首页热销产品的请求方法
- (void)loadHotProductCompletion:(void(^)(id responseData, NSError *error))complete;




@end
