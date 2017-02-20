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

/**
 问题 -->不能只定义一个属性记录请求回调结果,如果网速较慢,有多个网络请求的时候会发生请求结果回调错乱
 解决办法 -->回调的block作为参数传递进封装的方法内部,这样执行的时候都是各自的回调方法了,
 */
//@property (nonatomic, copy) void(^complete)(id responseData, NSError *error);

/** 提示框 */
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
// 在该方法内设置 cookie
- (void)loadLoopImagesCompletionHandler:(void(^)(id responseData, NSError *error))complete {
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    [headerFields setValue:@"application/json" forKey:@"Content-Type"];
    // ***** 如果不是第一次涉及到 cookie 这里一句代码保存 *****
    if ([Utils getUserCookie].length) {
        [headerFields setValue:[Utils getUserCookie] forKey:@"Cookie"];
    }
    
    MKNetworkEngine *engines = [[MKNetworkEngine alloc] initWithHostName:MKRequsetHeader customHeaderFields:headerFields];
    MKNetworkOperation *op = [engines operationWithPath:@"/turn/advertise" params:nil httpMethod:@"GET" ssl:NO];
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
//        if ([Utils getUserCookie].length == 0) {
//            NSDictionary *headerFieldDic = completedOperation.readonlyResponse.allHeaderFields;
//            NSString *cookie = headerFieldDic[@"Set-Cookie"];
//            [Utils storeCookie:cookie];
//        }
        
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
- (void)loadHotProductCompletionHandler:(void(^)(id responseData, NSError *error))complete {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/index/hotProduct" parameter:des3Str completionHandler:complete];
}

#pragma mark - 1.3 首页产品推荐网络请求方法
- (void)loadProductCommendCompletionHandler:(void(^)(id responseData, NSError *error))complete {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/index/recommendProduct" parameter:des3Str completionHandler:complete];
}

#pragma mark - 1.4 加载是否有新的未读消息的网络请求
- (void)loadUnreadMessageCompletionHandler:(void(^)(id responseData, NSError *error))complete {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/index/unReadMessage" parameter:des3Str completionHandler:complete];
}

#pragma mark - 2.1 登陆
- (void)loadUserDataOnLogInWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void (^)(id, NSError *))complete {
    
    NSString *jsonInput = [NSString stringWithFormat:@"{\"password\":\"%@\",\"userName\":\"%@\"}",password, userName];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/login" parameter:des3Str completionHandler:complete];
}

#pragma mark - 2.2 登陆之后,我的账户的网络请求
- (void)loadUserAccountDataAfterLogInCompletionHandler:(void(^)(id responseData, NSError *error))complete {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];

    [self PostEncodeRequestWithPath:@"/member/myAccount" parameter:des3Str completionHandler:complete];
}

#pragma mark - 2.3 找回密码控制器中,获取验证码的请求
- (void)loadNewAuthCodeWithPhone:(NSString *)phone completionHandler:(void(^)(id responseData, NSError *error))complete {
 
    NSInteger value = arc4random_uniform(1000 + 1);
    
    NSString *jsonInput = [NSString stringWithFormat:@"{\"busiType\":\"%@\",\"mathRandom\":\"%@\",\"mobile\":\"%@\"}", @"loginRet",[NSString stringWithFormat:@"%zd", value], phone];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/mobile/send/verifycode" parameter:des3Str completionHandler:complete];
}

#pragma mark - 2.4 重置密码
- (void)loadNewPasswordWithPhone:(NSString *)phone authCode:(NSString *)authCode newPassword:(NSString *)newPassword sureNewPassword:(NSString *)sureNewPassword completionHandler:(void (^)(id, NSError *))complete {

    NSString *jsonInput = [NSString stringWithFormat:@"{\"mobile\":\"%@\",\"password\":\"%@\",\"rePassword\":\"%@\",\"token\":\"%@\",\"validateCode\":\"%@\"}", phone, newPassword, sureNewPassword, [Utils getToken], authCode];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/password/retrieve" parameter:des3Str completionHandler:complete];
}

#pragma mark - 2.5 注册控制器中获取验证码的网络请求
- (void)loadRegisterAuthcodeWithPhone:(NSString *)phone completionHandler:(void(^)(id responseData, NSError *error))complete {

    NSInteger value = arc4random_uniform(1000 + 1);
    
    NSString *jsonInput = [NSString stringWithFormat:@"{\"busiType\":\"%@\",\"mathRandom\":\"%@\",\"mobile\":\"%@\"}", @"register",[NSString stringWithFormat:@"%zd", value], phone];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/mobile/send/verifycode" parameter:des3Str completionHandler:complete];
    
}

#pragma mark - 2.6 注册控制器中点击下一步按钮的网络请求
- (void)loadRegisterNextStepRequestWithPhone:(NSString *)phone authCode:(NSString *)authCode completionHandler:(void(^)(id responseData, NSError *error))complete {
    
    NSString *jsonInput = [NSString stringWithFormat:@"{\"mobile\":\"%@\",\"validateCode\":\"%@\"}", phone, authCode];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/mobile/send/verifycode" parameter:des3Str completionHandler:complete];
}

#pragma mark - 2.7 下一步注册控制器中 点击立即注册按钮的网络请求
- (void)loadRegisterAtOnceWithPassword:(NSString *)password nickName:(NSString *)nickName commendPhone:(NSString *)commendPhone selfPhone:(NSString *)selfPhone completionHandler:(void(^)(id responseData, NSError *error))complete {

    NSString *jsonInput = [NSString stringWithFormat:@"{\"channelManagerPhone\":\"%@\",\"mobile\":\"%@\",\"nickName\":\"%@\",\"password\":\"%@\"}", commendPhone, selfPhone, nickName, password];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/registerFinish" parameter:des3Str completionHandler:complete];
    
}

#pragma mark - 3.1 进入理财师认证控制器,如果已经认证就显示
- (void)loadAuthFinanPlanerRequestCompletionHandler:(void(^)(id responseData, NSError *error))complete {
    
    NSString *jsonInput = [NSString stringWithFormat:@"{\"token\":\"%@\"}",[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/toUserAudit" parameter:des3Str completionHandler:complete];
}

#pragma mark - 3.2 理财师认证控制器,上传认证证件图片
- (void)loadUploadImageWithFilePath:(NSString *)filePath completionHandler:(void(^)(id responseData, NSError *error))complete {
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    [headerFields setValue:@"application/json" forKey:@"Content-Type"];
    if ([Utils getUserCookie].length) {
        [headerFields setValue:[Utils getUserCookie] forKey:@"Cookie"];
    }
    
    MKNetworkEngine *engines = [[MKNetworkEngine alloc] initWithHostName:MKRequsetHeader customHeaderFields:headerFields];
    MKNetworkOperation *op = [engines operationWithPath:@"auditUser/ios/uploadFile" params:nil httpMethod:@"POST" ssl:NO];
    [op addFile:filePath forKey:@"photo"];
    [op setFreezable:YES];
    if (![self isNetCanUse]) {
        return;
    }
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        
        NSString *des3Str = completedOperation.responseString;
        
        NSData *data = [des3Str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        complete(responseDict, nil);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        complete(nil, error);
    }];
    
    [engines enqueueOperation:op];
}

#pragma mark - 3.3 理财师认证控制器,提交认证请求
- (void)loadCommitAuthFinanPlanerRequestWithBusinessCardName:(NSString *)businessCardName companyName:(NSString *)companyName email:(NSString *)email mobile:(NSString *)mobile realName:(NSString *)realName regionaCity:(NSString *)regionaCity regionaProvince:(NSString *)regionaProvince completionHandler:(void(^)(id responseData, NSError *error))complete {
    
    NSString *jsonInput = [NSString stringWithFormat:@"{\"businessCardName\":\"%@\",\"companyName\":\"%@\",\"email\":\"%@\",\"mobile\":\"%@\",\"realName\":\"%@\",\"regionaCity\":\"%@\",\"regionaProvince\":\"%@\",\"token\":\"%@\"}",businessCardName,companyName,email,mobile,realName,regionaCity,regionaProvince,[Utils getToken]];
    // 加密的签名
    NSString *md5Str = [jsonInput yh_md5String];
    NSString *lowermd5Str = [md5Str lowercaseString];
    NSString *jsonInputStr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5Str,jsonInput];
    //加密
    NSString *des3Str = [DES3Util encrypt:jsonInputStr];
    
    [self PostEncodeRequestWithPath:@"/ios/user/toAudit" parameter:des3Str completionHandler:complete];
}







#pragma mark - POST的加密请求--> 公共方法
- (void)PostEncodeRequestWithPath:(NSString *)path parameter:(NSString *)des3Str completionHandler:(void(^)(id responseData, NSError *error))complete {
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    [headerFields setValue:@"application/json" forKey:@"Content-Type"];
    // ***** 如果不是第一次涉及到 cookie 这里一句代码保存 *****
    if ([Utils getUserCookie].length) {
        [headerFields setValue:[Utils getUserCookie] forKey:@"Cookie"];
    }
    
    MKNetworkEngine *engines = [[MKNetworkEngine alloc] initWithHostName:MKRequsetHeader customHeaderFields:headerFields];
    MKNetworkOperation *op = [engines operationWithPath:path params:nil httpMethod:@"POST" ssl:NO];
    op.postDataEncoding = MKNKPostDataEncodingTypeCustom;
    // ****** 如果是有参数,并且是字符串的,在这里设置  下面三句代码
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        return des3Str;
    } forType:@"txt/xml"];
    
    if (![self isNetCanUse]) {
        return;
    }
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if ([path isEqualToString:@"/ios/user/login"]) {
            NSDictionary *headerFieldDic = completedOperation.readonlyResponse.allHeaderFields;
            NSString *cookie = headerFieldDic[@"Set-Cookie"];
            [Utils storeCookie:cookie];
        }
        
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
