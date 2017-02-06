//
//  YHNetworkManager.h
//  CF360
//
//  Created by junde on 2017/1/16.
//  Copyright © 2017年 junde. All rights reserved.
//


/**
    使用 AFN 作为网络请求工具,同时对其进行简单的封装
 */
#import <AFNetworking/AFNetworking.h>

@interface YHNetworkManager : AFHTTPSessionManager

#pragma mark - 单例设计,用于初始化网络工具
+ (instancetype)shareManager;

#pragma mark - 首页轮播图网络请求
+ (void)loadLoopImagesCompletion:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 首页热销产品的请求方法
+ (void)loadHotProductCompletion:(void(^)(id responseData, NSError *error))complete;



@end
