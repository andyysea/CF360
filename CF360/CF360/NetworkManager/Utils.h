//
//  Utils.h
//  CF360
//
//  Created by kingstartimes on 15/10/14.
//  Copyright (c) 2015年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


/**
*校验密码是否合法（密码必须包含字母和数字且6位以上）
*@param	str	用户名
*@return		用户名是否合法
*/
+ (BOOL)validatePassword : (NSString *) str;

/**
 *校验用户手机号码是否合法
 *@param	phoneNum	手机号码
 *@return		手机号是否合法
 */
+ (BOOL)validateUserPhone:(NSString *)phoneNum;


/**
 *校验用户邮箱是否合法
 *@param	str	邮箱
 *@return		邮箱是否合法
 */
+ (BOOL)validateEmail:(NSString *)str;

/**
 *校验钱的金额是否合法
 *@param	str	金额
 *@return		金额是否合法
 */
+ (BOOL)validateRMB:(NSString *)str;

/**
 *校验身份证证号是否合法
 *@param	str	身份证号
 *@return		身份证号是否合法
 */
+ (BOOL)validateIDCard:(NSString *)str;

//存储token
+ (BOOL)storeToken:(NSString *)token;
+ (NSString *)getToken;

//存储cookie
+ (BOOL)storeCookie:(NSString *)cookie;
+ (NSString *)getUserCookie;

// 存储登陆状态
+ (BOOL)storeLoginStates:(BOOL)loginStates;
+ (BOOL)getLoginStates;
// 存储用户 ID
+ (BOOL)storeUserID:(NSString *)userID;
+ (NSString *)getUserID;
// 存储昵称
+ (BOOL)storeNickName:(NSString *)nickName;
+ (NSString *)getNickName;
// 存储真实名字
+ (BOOL)storeRealName:(NSString *)realName;
+ (NSString *)getRealName;
// 存储电话
+ (BOOL)storePhone:(NSString *)Phone;
+ (NSString *)getPhone;
// 存储类型
+ (BOOL)storeUserType:(NSString *)type;
+ (NSString *)getUserType;
// 存储用户密码
+ (BOOL)storeUserpwd:(NSString *)userpwd;
+ (NSString *)getUserpwd;



//百度唯一标识
+ (BOOL)storeBaiDuChannelIdCode:(NSString *)recommendCode;
+ (NSString *)getBaiDuChannelId;
//deviceToken
+ (BOOL)storeDeviceToken:(NSData *)deviceToken;
+ (NSData *)getDeviceToken;
//推送开关唯一标识
+ (BOOL)storeTuiSong:(NSString*)isOpen;
+ (NSString*)getTuiSong;

@end
