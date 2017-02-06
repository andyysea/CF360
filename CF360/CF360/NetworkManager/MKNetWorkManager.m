//
//  MKNetWorkManager.m
//  CF360
//
//  Created by junde on 2017/2/6.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "MKNetWorkManager.h"

#import "DES3Util.h"
#import "Utils.h"

@interface MKNetWorkManager ()

@property (nonatomic, strong) UIAlertView *alert;;

@end

@implementation MKNetWorkManager

#pragma mark - 单例设计,用于初始化网络工具类
+ (instancetype)shareManager {
    static MKNetWorkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark - 1.1 首页轮播图网络请求
- (void)loadLoopImagesCompletion:(void(^)(id responseData, NSError *error))complete {
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    [headerFields setValue:@"application/json" forKey:@"Content-Type"];
    // ***** 如果不是第一次涉及到 cookie 这里一句代码保存 *****
    [headerFields setValue:[Utils getUserCookie] forKey:@"Cookie"];
    
    MKNetworkEngine *engines = [[MKNetworkEngine alloc] initWithHostName:MKRequsetHeader customHeaderFields:headerFields];
    MKNetworkOperation *op = [engines operationWithPath:@"/turn/advertise" params:nil httpMethod:@"GET" ssl:YES];
    op.postDataEncoding = MKNKPostDataEncodingTypeCustom;
    // ***** 如果是有参数,并且是字符串的,在这里设置  下面三句代码 *****
    //    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
    //        return des3Str;
    //    } forType:@"txt/xml"];
    
    if (![self isNetCanUse]) {
        return;
    }
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        // ***** 第一次网络请求涉及到 cookie 的时候 这里三句代码 保存 ******
        NSDictionary *headerFieldDic = completedOperation.readonlyResponse.allHeaderFields;
        NSString *cookie = headerFieldDic[@"Set-Cookie"];
        [Utils storeCookie:cookie];
        
        NSString *des3Str = completedOperation.responseString;
        
        NSData *data = [des3Str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        complete(responseDict, nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        complete (nil, error);
    }];
    
    [engines enqueueOperation:op];
    
}

#pragma mark - 1.2 首页热销产品的请求方法
- (void)loadHotProductCompletion:(void(^)(id responseData, NSError *error))complete {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    [headerFields setValue:@"application/json" forKey:@"Content-Type"];
    // ***** 如果不是第一次涉及到 cookie 这里一句代码保存 *****
    [headerFields setValue:[Utils getUserCookie] forKey:@"Cookie"];
    
    MKNetworkEngine *engines = [[MKNetworkEngine alloc] initWithHostName:MKRequsetHeader customHeaderFields:headerFields];
    MKNetworkOperation *op = [engines operationWithPath:@"/index/hotProduct" params:nil httpMethod:@"POST" ssl:YES];
    op.postDataEncoding = MKNKPostDataEncodingTypeCustom;
    // ****** 如果是有参数,并且是字符串的,在这里设置  下面三句代码
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        return des3Str;
    } forType:@"txt/xml"];
    
    if (![self isNetCanUse]) {
        return;
    }
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *des3Str = completedOperation.responseString;
        NSString *dataStr = [DES3Util decrypt:des3Str];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        complete(responseDict, nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        complete (nil, error);
    }];
    
    [engines enqueueOperation:op];
}





#pragma mark - 判断网络是否可用
- (BOOL)isNetCanUse
{
    //检测网络
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable://没有网络
        {
            if (self.alert == nil) {
                
                NSString *tipName = @"网络提示";
                self.alert = [[UIAlertView alloc] initWithTitle:tipName
                                                        message:@"网络不给力，请检查网络设置"
                                                       delegate: nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles: nil, nil];
                [self.alert show];
            }
            return NO;
            break;
        }
        case ReachableViaWWAN://3G/4G网络
        {
            return YES;
            break;
        }
        case ReachableViaWiFi://WiFi
        {
            return YES;
            break;
        }
        default:
            break;
    }
}
@end
