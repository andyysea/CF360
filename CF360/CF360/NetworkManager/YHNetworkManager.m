//
//  YHNetworkManager.m
//  CF360
//
//  Created by junde on 2017/1/16.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "YHNetworkManager.h"
#import "Utils.h"
#import "DES3Util.h"

@implementation YHNetworkManager

#pragma mark - 单例设计,用于初始化网络工具
+ (instancetype)shareManager {
    static YHNetworkManager *instance = nil;
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

#pragma mark - 首页热销产品的请求方法
+ (void)loadHotProductCompletion:(void(^)(id responseData, NSError *error))complete {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    NSString *urlString = [NSString stringWithFormat:@"%@", RequestHeader];
    urlString = [urlString stringByAppendingString:@"/index/hotProduct"];
    
    // ****** 这里的 des3Str 是字符串,不是字典 *****
    
    [[YHNetworkManager shareManager] POST:urlString parameters:des3Str progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
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
