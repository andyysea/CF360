//
//  YHNetworkManager.h
//  CF360
//
//  Created by junde on 2017/1/16.
//  Copyright © 2017年 junde. All rights reserved.
//



/**
 使用 AFN 作为网络请求工具,同时对其进行简单的封装
 问题:
 - 1> 由于后台架构的问题,如果有参数,必须将参数加密为字符串再作为参数 -->AFN 3.0 的参数默认的是字典,如果修改必须修改源码 --> 这一点暂时没有解决
 - 2> AFN 3.0 的返回结果默认也是反序列化之后的返回结果,是数组或者字典, --> 而后台返回的是加密的字符串,移动端拿到之后需要解密得到需要的
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
