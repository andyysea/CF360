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

#pragma mark - 1.1 首页轮播图网络请求方法
- (void)loadLoopImagesCompletionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 1.2 首页热销产品的请求方法
- (void)loadHotProductCompletionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 1.3 首页产品推荐网络请求方法
- (void)loadProductCommendCompletionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 1.4 加载是否有新的未读消息的网络请求
- (void)loadUnreadMessageCompletionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.1 登陆
- (void)loadUserDataOnLogInWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.2 登陆之后,我的账的网络请求
// 这个网络请求是登陆之后,再次代开左侧菜单控制器的请求
- (void)loadUserAccountDataAfterLogInCompletionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.3 找回密码控制器中,获取验证码的请求
- (void)loadNewAuthCodeWithPhone:(NSString *)phone completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.4 重置密码
- (void)loadNewPasswordWithPhone:(NSString *)phone authCode:(NSString *)authCode newPassword:(NSString *)newPassword sureNewPassword:(NSString *)sureNewPassword completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.5 注册控制器中获取验证码的网络请求
- (void)loadRegisterAuthcodeWithPhone:(NSString *)phone completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.6 注册控制器中点击下一步按钮的网络请求
- (void)loadRegisterNextStepRequestWithPhone:(NSString *)phone authCode:(NSString *)authCode completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 2.7 下一步注册控制器中 点击立即注册按钮的网络请求
- (void)loadRegisterAtOnceWithPassword:(NSString *)password nickName:(NSString *)nickName commendPhone:(NSString *)commendPhone selfPhone:(NSString *)selfPhone completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 3.1 进入理财师认证控制器,如果已经认证就显示
- (void)loadAuthFinanPlanerRequestCompletionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 3.2 理财师认证控制器,上传认证证件图片
- (void)loadUploadImageWithFilePath:(NSString *)filePath completionHandler:(void(^)(id responseData, NSError *error))complete;

#pragma mark - 3.3 理财师认证控制器,提交认证请求
- (void)loadCommitAuthFinanPlanerRequestWithBusinessCardName:(NSString *)businessCardName companyName:(NSString *)companyName email:(NSString *)email mobile:(NSString *)mobile realName:(NSString *)realName regionaCity:(NSString *)regionaCity regionaProvince:(NSString *)regionaProvince completionHandler:(void(^)(id responseData, NSError *error))complete;



@end








