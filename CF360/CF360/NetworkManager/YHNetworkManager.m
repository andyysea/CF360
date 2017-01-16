//
//  YHNetworkManager.m
//  CF360
//
//  Created by junde on 2017/1/16.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "YHNetworkManager.h"

@implementation YHNetworkManager

#pragma mark - 单例设计,用于初始化网络工具
+ (instancetype)shareManager {
    static YHNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.requestSerializer.timeoutInterval = 10.f;
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;
}

#pragma mark - 首页轮播图网络请求
+ (void)loadLoopImagesCompletion:(void(^)(id responseData, NSError *error))complete {
    NSString *urlString = [NSString stringWithFormat:@"%@", RequestHeader];
    urlString = [urlString stringByAppendingString:@"/turn/advertise"];
    
    [[YHNetworkManager shareManager] GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject--> %@",responseObject);
    
        if (responseObject && complete) {
            complete(responseObject, nil);
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error --> %@",error);
        if (error && complete) {
            complete(nil, error);
        }
    }];
}



@end
